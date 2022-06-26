self: super:
{
  volnoti = super.volnoti.overrideAttrs (_: rec {
    patches = [
      # New icon for display brightness, accessed via volnoti-show -b, see
      # https://github.com/davidbrazdil/volnoti/pull/14
      (super.fetchpatch {
        url = "https://github.com/davidbrazdil/volnoti/pull/14.patch";
        sha256 = "sha256-NTyKuYK4w1flCV5NJzVIVcptNrxfYQ7/UGmD7BNQ6x0=";
      })
    ];
  });
}
