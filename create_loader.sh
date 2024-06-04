MODULE=sentiment

usage()
{
    cat <<EOF
$0 TARGET ARTIFACT

TARGET    [ debug | release ]
ARTIFACT  [ standalone | extension_embed | extension ]

EOF
}

[ $# -ne 2 ] && usage

TARGET="$1"
case "$TARGET" in
    debug)   ;;
    release) ;;
    *)       usage ;;
esac

ARTIFACT="$2"
case "$ARTIFACT" in
    standalone)      ;;
    extension_embed) ;;
    extension)       ;;
    *)               usage ;;
esac

WASM_PATH=target/wasm32-wasi/$TARGET/$MODULE.wasm
WIT_PATH=$MODULE.wit
EXT_PATH=target/$MODULE.tar

WASM_B64=$(base64 -w 0 "${WASM_PATH}")
WIT_B64=$(base64 -w 0 "${WIT_PATH}")

OUTFILE_STANDALONE=load_standalone.sql
OUTFILE_EXTENSION_EMBED=$MODULE.sql
OUTFILE_EXTENSION=load_extension.sql

emit_extension_stmts()
{
    EXT_B64=$(base64 -w 0 "${EXT_PATH}")
    cat <<EOF >> $OUTFILE_EXTENSION
DROP EXTENSION IF EXISTS $MODULE;
CREATE EXTENSION $MODULE FROM BASE64 '$EXT_B64';
EOF
}

emit_function_stmts()
{
    case "$ARTIFACT" in
        standalone)
            MAYBE_REPLACE="OR REPLACE"
            WASM_CONTENT_SRC="BASE64 '$WASM_B64'"
            WIT_CONTENT_SRC="BASE64 '$WIT_B64'"
            OUTFILE="$OUTFILE_STANDALONE"
            ;;
        extension_embed)
            MAYBE_REPLACE=""
            WASM_CONTENT_SRC="LOCAL INFILE '`basename $WASM_PATH`'"
            WIT_CONTENT_SRC="LOCAL INFILE '`basename $WIT_PATH`'"
            OUTFILE="$OUTFILE_EXTENSION_EMBED"
            ;;
        *)
            usage
            ;;
    esac

    cat <<EOF > "$OUTFILE"
CREATE $MAYBE_REPLACE FUNCTION sentiment
AS WASM FROM $WASM_CONTENT_SRC
WITH WIT FROM $WIT_CONTENT_SRC;

CREATE $MAYBE_REPLACE FUNCTION sentiment_tvf RETURNS TABLE
AS WASM FROM $WASM_CONTENT_SRC
WITH WIT FROM $WIT_CONTENT_SRC;
EOF
}

if [ "$ARTIFACT" = "extension" ] ; then
    emit_extension_stmts
else
    emit_function_stmts
fi

echo "Loader '$ARTIFACT' created successfully ($TARGET)."
