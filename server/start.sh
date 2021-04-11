  #!/bin/bash

export MIX_ENV=prod
export PORT=4795

CFGD=$(readlink -f ~/.config/final)

if [ ! -e "$CFGD/base" ]; then
    echo "run deploy first"
    exit 1
fi

DB_PASS=$(cat "$CFGD/db_pass")
export DATABASE_URL=ecto://final:$DB_PASS@localhost/final_project_prod

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

_build/prod/rel/final_project/bin/final_project start