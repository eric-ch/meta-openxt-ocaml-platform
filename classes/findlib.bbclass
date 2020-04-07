DEPENDS_append_class-native = " \
    findlib-native \
"
DEPENDS_append_class-target = " \
    findlib-native \
    virtual/${TARGET_PREFIX}ocamlfind-meta \
"

# location where ocamlfind install puts the packages.
sitelibdir = "${ocamllibdir}/site-lib"
export sitelibdir

OCAMLFIND_CONF = "${STAGING_DIR_NATIVE}/etc/findlib.conf"
export OCAMLFIND_CONF

FILES_${PN} = " \
    ${sitelibdir}/*/*${SOLIBSDEV} \
    ${bindir}/* \
    ${sbindir}/* \
"
FILES_${PN}-dev = " \
    ${sitelibdir}/*/*.cm* \
    ${sitelibdir}/*/*.mli \
    ${sitelibdir}/*/META \
"
FILES_${PN}-staticdev = " \
    ${sitelibdir}/*/*.a \
"
FILES_${PN}-dbg = " \
    ${sitelibdir}/*/.debug \
    ${bindir}/.debug \
    ${sbindir}/.debug \
    /usr/src/debug \
"

do_amend_findlib_conf() {
    sed -i \
        -e 's|^destdir=.*|destdir="${D}${sitelibdir}"|' \
        -e 's|^path=.*|path="${OCAMLLIB}/site-lib:${STAGING_LIBDIR}/ocaml/site-lib"|' \
            "${STAGING_DIR_NATIVE}/etc/findlib.conf"
    if ! grep -q '^ldconf=' "${STAGING_DIR_NATIVE}/etc/findlib.conf"; then
        echo 'ldconf="ignore"' >> "${STAGING_DIR_NATIVE}/etc/findlib.conf"
    else
        sed -i -e 's|^ldconf=.*|ldconf="ignore"|' "${STAGING_DIR_NATIVE}/etc/findlib.conf"
    fi
}
do_prepare_recipe_sysroot[postfuncs] += "do_amend_findlib_conf"

do_install_prepend() {
    install -d ${D}${sitelibdir}
}
