runcmd:
  - [ spectool, -g, -C, /tmp/rpmbuild/SOURCES, /tmp/rpmbuild/SPECS/${package_name}.spec ]
  - [ rpmbuild, -ba, --define, "_topdir /tmp/rpmbuild", /tmp/rpmbuild/SPECS/${package_name}.spec ]
