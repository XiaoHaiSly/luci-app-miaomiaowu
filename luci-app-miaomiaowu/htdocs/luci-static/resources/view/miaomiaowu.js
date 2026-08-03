'use strict';
'require view';
'require form';
'require uci';
'require rpc';
'require fs';
'require ui';
'require poll';

var callServiceList = rpc.declare({
	object: 'service',
	method: 'list',
	params: ['name'],
	expect: { '': {} }
});

function getServiceStatus() {
	return callServiceList('miaomiaowu').then(function (res) {
		var running = false;
		try {
			running = res['miaomiaowu']['instances']['instance1']['running'];
		} catch (e) {}
		return running;
	});
}

function statusHtml(running) {
	return '<span style="width:8px;height:8px;border-radius:50%;background:' + (running ? '#5cb85c' : '#d9534f') + ';display:inline-block;"></span>' +
		'<span style="font-size:13px;font-weight:600;color:' + (running ? '#3c763d' : '#a94442') + ';margin-left:6px;">' +
		(running ? _('运行中') : _('未运行')) + '</span>';
}

function injectTapCss() {
	if (document.getElementById('mmw_tap_css')) return;
	var style = document.createElement('style');
	style.id = 'mmw_tap_css';
	style.textContent =
		'@keyframes mmw_tap { 0% { transform:scale(1); } 50% { transform:scale(0.94); opacity:0.75; } 100% { transform:scale(1); } }' +
		'.mmw_tap { animation: mmw_tap 0.3s ease; }';
	document.head.appendChild(style);
}

return view.extend({
	load: function () {
		return Promise.all([uci.load('miaomiaowu'), getServiceStatus()]);
	},

	render: function (data) {
		var state = { running: data[1] };
		var m, s, o;

		m = new form.Map('miaomiaowu', _('妙妙屋'), _('Clash 配置订阅管理工具') +
			'<div id="mmw_status_wrap" style="margin-top:6px;display:flex;align-items:center;">' +
			statusHtml(state.running) +
			'</div>');

		s = m.section(form.NamedSection, 'miaomiaowu', 'miaomiaowu', _('基本设置'));
		s.anonymous = true;

		o = s.option(form.Button, '_open_panel', _('Web 面板'));
		o.inputstyle = 'action';
		o.inputtitle = _('打开面板');
		o.onclick = function (ev) {
			injectTapCss();
			var btn = (ev && (ev.currentTarget || ev.target)) || null;
			if (btn) {
				btn.classList.remove('mmw_tap');
				void btn.offsetWidth;
				btn.classList.add('mmw_tap');
			}
			if (!state.running) {
				return;
			}
			var port = uci.get('miaomiaowu', 'miaomiaowu', 'port') || '7852';
			window.open('http://' + window.location.hostname + ':' + port + '/', '_blank');
		};

		o = s.option(form.Flag, 'enabled', _('启用'));
		o.default = '1';
		o.rmempty = false;

		o = s.option(form.Value, 'port', _('监听端口'));
		o.datatype = 'port';
		o.default = '8080';

		o = s.option(form.Value, 'database_path', _('数据库路径'), _('SQLite 数据库文件存放路径'));
		o.default = '/etc/mmw/traffic.db';
		o.rmempty = false;

		o = s.option(form.ListValue, 'log_level', _('日志级别'));
		o.value('debug', 'debug');
		o.value('info', 'info');
		o.value('warn', 'warn');
		o.value('error', 'error');
		o.default = 'info';

		poll.add(function () {
			return getServiceStatus().then(function (running) {
				state.running = running;
				var el = document.getElementById('mmw_status_wrap');
				if (el) el.innerHTML = statusHtml(running);
			});
		});

		return m.render();
	},

	handleSaveApply: function (ev, mode) {
		var self = this;
		return this.handleSave(ev).then(function () {
			return ui.changes.apply(mode == '0');
		}).then(function () {
			var enabled = uci.get('miaomiaowu', 'miaomiaowu', 'enabled');
			var action = (enabled === '1') ? 'start' : 'stop';
			return fs.exec('/etc/init.d/miaomiaowu', [action]);
		}).then(function () {
			return getServiceStatus();
		}).then(function (running) {
			var el = document.getElementById('mmw_status_wrap');
			if (el) el.innerHTML = statusHtml(running);
		}).catch(function (err) {
			ui.addNotification(null, E('p', _('操作失败: ') + (err && err.message ? err.message : err)));
		});
	}
});
