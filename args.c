#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "args_parser.h"

int usage(void) {

    fprintf(stderr, "USAGE: args <pid>\n");

    return 1;
}

int main(int argc, const char * const argv[])
{

    struct args_opts_s opts = {0};
    int ret = parse_args(argc, argv, &opts);
    if (-1 == ret) {
        return usage();
    }

    if (true == opts.verbose) {
        printf("verbose\n");
    }
    return ret;
}
