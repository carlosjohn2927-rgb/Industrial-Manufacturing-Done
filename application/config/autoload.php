<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Vortex Precision - autoload configuration.
 */
$autoload['packages'] = [];
$autoload['libraries'] = ['database', 'session', 'vp_auth', 'rbac', 'settings', 'audit', 'rate_limiter', 'mailer'];
$autoload['drivers'] = [];
$autoload['helper'] = ['url', 'form', 'text', 'date', 'app', 'security_helper'];
$autoload['config'] = [];
$autoload['language'] = ['app_lang'];
$autoload['model'] = [];
