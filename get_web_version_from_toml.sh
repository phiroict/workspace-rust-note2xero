VERSION_DATA=$(cat noted2xero_web/Cargo.toml  | grep "^version" | tr " = " "\n")
echo "${VERSION_DATA##*$'\n'}" | sed "s/\"//g"