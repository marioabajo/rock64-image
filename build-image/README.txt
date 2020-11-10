Number  Start (sector)    End (sector)  Size       Code  Name
   1              64            7167   3.5 MiB     8300  loader1
   2           16384           24575   4.0 MiB     8300  loader2
   3           24576        15523806   7.4 GiB     8300  rootfs

Partition number (1-3): 3
Known attributes are:
0: system partition
1: hide from EFI
2: legacy BIOS bootable
60: read-only
62: hidden
63: do not automount

Attribute value is 0000000000000004. Set fields are:
2 (legacy BIOS bootable)


turin@thanos:~/rock64-image/buildroot-2020.05$ cp output/images/u-boot.itb /dev/sdg2
turin@thanos:~/rock64-image/buildroot-2020.05$ cp output/images/u-boot.itb /dev/sdg
sdg   sdg1  sdg2  sdg3  
turin@thanos:~/rock64-image/buildroot-2020.05$ cp output/images/rootfs.ext4 /dev/sdg3 

