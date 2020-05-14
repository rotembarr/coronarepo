#include <stdio.h>

#define BUFF_LEN 1024 // Max length of buffer
#define IP_LEN   20   // Max length of ip

int valid_ip (char *str) {
    int segs = 0;    // Segment count
    int ch_cnt = 0;  // Character count within segment
    int accum = 0;   // Accumulator for segment

    // Catch NULL pointer
    if (str == NULL)
        return 0;

    // Process every character in string
    while (*str != '\n' && *str != '\0') {
        // Segment changeover
        if (*str == '.') {
            // Must have some digits in segment
            if (ch_cnt == 0)
                return 0;
            // Limit number of segments
            if (++segs == 4)
                return 0;
            // Reset segment values and restart loop
            ch_cnt = accum = 0;
            str++;
            continue;
        }
        // Check numeric
        if ((*str < '0') || (*str > '9'))
            return 0;
        // Preventing starting with '0'
        if ((ch_cnt > 0) && (accum == 0))
            return 0;
        // Accumulate and check segment
        if ((accum = accum * 10 + *str - '0') > 255)
            return 0;
        // Advance other segment specific stuff and continue loop
        ch_cnt++;
        str++;
    }

    // Check enough segments and enough characters in last segment
    if (segs != 3)
        return 0;
    if (ch_cnt == 0)
        return 0;

    // Address okay 
    return 1;
}