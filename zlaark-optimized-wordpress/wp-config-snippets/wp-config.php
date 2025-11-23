// wp-config.php snippets

// DB & salts (use env & secrets)
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));

// WP table prefix
$table_prefix = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';

// Redis (Dragonfly) object cache
define('WP_REDIS_HOST', 'redis');    // container name
define('WP_REDIS_PORT', 6379);
define('WP_CACHE', true);

// Disable WP Heartbeat high frequency on admin side if not needed
define('AUTOSAVE_INTERVAL', 300); // seconds
define('WP_POST_REVISIONS', 5);

// Improve REST API performance: disable unnecessary endpoints if possible
// Example: disable post revisions in REST responses (customize to your needs)
add_filter('rest_endpoints', function($endpoints) {
    // Optionally unset endpoints you don't use
    // unset($endpoints['/wp/v2/comments']);
    return $endpoints;
});

// Force WP to use HTTPS (if you front with HTTPS load balancer)
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
  $_SERVER['HTTPS'] = 'on';
}
