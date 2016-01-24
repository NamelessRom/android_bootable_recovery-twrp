#ifndef RECOVERY_TWINSTALL_H_
#define RECOVERY_TWINSTALL_H_

#ifdef __cplusplus
extern "C" {
#endif

int TWinstall_zip(const char* path, int* wipe_cache);

void set_perf_mode(bool enable);

#ifdef __cplusplus
}
#endif

#endif  // RECOVERY_TWINSTALL_H_
