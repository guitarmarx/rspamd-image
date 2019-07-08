bind_socket =0.0.0.0:11332;

# this worker will be used as postfix milter
milter = yes;

timeout = 120s;
upstream "local" {
    default = yes;
    self_scan = yes;
}