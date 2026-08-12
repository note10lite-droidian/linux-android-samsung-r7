/*
 * Samsung DP Audio driver
 *
 * Copyright (c) 2017 Samsung Electronics Co. Ltd.
  *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#ifndef __DPADO_H
#define __DPADO_H

/* r7-server: the guard also has to require the provider, not just the SoC.
 * dp_ado_switch_set_state() is defined in sound/soc/samsung/dp_dma.c, which
 * is built by CONFIG_SND_SOC_SAMSUNG_DISPLAYPORT. This fork strips the whole
 * audio stack, so on EXYNOS9810 the old guard still declared the prototype
 * while nothing defined it, and displayport_drv.c failed to link.
 *
 * The no-op is safe (unlike a stub that returns a fake address): this call
 * only notifies the audio side that DP audio became available or went away,
 * and with no audio subsystem there is nothing to notify. Note the original
 * #else branch also had a typo - it defined dp_ado_set_state, missing the
 * _switch - which never mattered because that branch was unreachable on this
 * SoC. Fixed here since it is now reachable.
 */
#if defined(CONFIG_SOC_EXYNOS9810) && IS_ENABLED(CONFIG_SND_SOC_SAMSUNG_DISPLAYPORT)
void dp_ado_switch_set_state(int state);
#else
static inline void dp_ado_switch_set_state(int state) { }
#endif

#endif /* __DPADO_H */
