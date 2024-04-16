{
  config,
  lib,
  nodes,
  pkgs,
  ...
}:
{
  users.groups.git = {};
  users.users.git = {
    isSystemUser = true;
    useDefaultShell = true;
    group = "git";
    home = config.services.forgejo.stateDir;
  };

  services.openssh = {
    # Recommended by forgejo: https://forgejo.org/docs/latest/admin/recommendations/#git-over-ssh
    settings.AcceptEnv = "GIT_PROTOCOL";
  };

  services.forgejo = {
    enable = true;
    user = "git";
    group = "git";
    lfs.enable = true;
    settings = {
      DEFAULT.APP_NAME = "Leo Git";
      actions = {
        ENABLED = true;
        DEFAULT_ACTIONS_URL = "github";
      };
      database = {
        SQLITE_JOURNAL_MODE = "WAL";
        LOG_SQL = false; # Leaks secrets
      };
      repository = {
        DEFAULT_PRIVATE = "private";
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
      };
      server = {
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        DOMAIN = "git.craftcat.dev";
        ROOT_URL = "https://git.craftcat.dev/";
        LANDING_PAGE = "login";
        SSH_PORT = 9922;
        SSH_USER = "git";
      };
      session.COOKIE_SECURE = true;
      ui.DEFAULT_THEME = "forgejo-auto";
      "ui.meta" = {
        AUTHOR = "Leo Git";
        DESCRIPTION = "Infrastructure Repository";
      };
    };
  };

}