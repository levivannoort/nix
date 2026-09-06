{ ... }:

{
  programs.k9s = {
    enable = true;

    settings.k9s = {
      liveViewAutoRefresh = false;
      refreshRate = 2;
      maxConnRetry = 5;
      ui = {
        skin = "default";
        enableMouse = false;
        headless = false;
        logoless = true;
        crumbsless = false;
        readOnly = false;
        noExitOnCtrlC = false;
        noIcons = true;
        skipLatestRevCheck = true;
      };
      logger = {
        tail = 200;
        buffer = 5000;
        sinceSeconds = 300;
        fullScreenLogs = false;
        textWrap = false;
        showTime = false;
      };
      thresholds = {
        cpu = {
          critical = 90;
          warn = 70;
        };
        memory = {
          critical = 90;
          warn = 70;
        };
      };
    };

    aliases.aliases = {
      dp = "deployments";
      sec = "v1/secrets";
      jo = "jobs";
      cr = "clusterroles";
      crb = "clusterrolebindings";
      ro = "roles";
      rb = "rolebindings";
      np = "networkpolicies";
    };

    skins.default =
      let
        foreground = "#ffffff";
        background = "default";
        backgroundOpaque = "#333333";
        red = "#e0656b";
        orange = "#e47c20";
        green = "#a7e24c";
      in
      {
        k9s = {
          body = {
            fgColor = foreground;
            bgColor = background;
            logoColor = red;
          };
          prompt = {
            fgColor = green;
            bgColor = background;
            suggestColor = orange;
          };
          info = {
            fgColor = foreground;
            sectionColor = green;
          };
          dialog = {
            fgColor = foreground;
            bgColor = background;
            buttonFgColor = foreground;
            buttonBgColor = green;
            buttonFocusFgColor = foreground;
            buttonFocusBgColor = green;
            labelFgColor = green;
            fieldFgColor = green;
          };
          frame = {
            border = {
              fgColor = green;
              focusColor = green;
            };
            menu = {
              fgColor = green;
              keyColor = foreground;
              numKeyColor = green;
            };
            crumbs = {
              fgColor = foreground;
              bgColor = backgroundOpaque;
              activeColor = foreground;
            };
            status = {
              newColor = green;
              modifyColor = red;
              addColor = green;
              pendingColor = orange;
              errorColor = red;
              highlightcolor = green;
              killColor = green;
              completedColor = green;
            };
            title = {
              fgColor = foreground;
              bgColor = background;
              highlightColor = green;
              counterColor = foreground;
              filterColor = orange;
            };
          };
          views.charts = {
            bgColor = background;
            dialBgColor = background;
            chartBgColor = backgroundOpaque;
          };
        };
      };
  };
}
