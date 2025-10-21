#!/bin/bash
# 6_dryrun.sh – testi, mis failid läheksid varundusse, kuid ära loo arhiivi
tar -cf - -C ~/praks2 src | tar -tvf -
