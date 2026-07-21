Name:           verithyst-cachyos-kernel
Version:        1.0
Release:        1%{?dist}
Summary:        Verithyst Gaming Kernel based on CachyOS

License:        GPLv2
URL:            https://github.com/CachyOS/linux-cachyos

BuildArch:      x86_64


%description
Gaming optimized kernel package for Verithyst.
Based on CachyOS kernel sources.


%prep


%build


%install

mkdir -p %{buildroot}/usr/share/verithyst/kernel


cat > %{buildroot}/usr/share/verithyst/kernel/info <<EOF
Verithyst Gaming Kernel
Base: CachyOS
Scheduler: Gaming optimized
EOF


%files

/usr/share/verithyst/kernel/info


%changelog

* Tue Jul 21 2026 Verithyst Team
- Initial package
