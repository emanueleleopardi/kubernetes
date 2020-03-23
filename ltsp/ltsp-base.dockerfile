FROM ubuntu:16.04 as ltsp-base

ADD nbd-server-wrapper.sh /bin/
ADD /patches/feature-grub.diff /patches/feature-grub.diff
RUN apt-get -y update \
 && apt-get -y install \
      ltsp-server \
      tftpd-hpa \
      nbd-server \
      grub-common \
      grub-pc-bin \
      grub-efi-amd64-bin \
      curl \
      patch \
 && sed -i 's|in_target mount|in_target_nofail mount|' \
      /usr/share/debootstrap/functions \
  # Add EFI support and Grub bootloader (#1745251)
 && patch -p2 -d /usr/sbin < /patches/feature-grub.diff \
 && rm -rf /var/lib/apt/lists \
 && apt-get clean