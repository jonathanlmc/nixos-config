{ pkgs, ... }:

{
  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    enableAllFirmware = true;

    bluetooth.enable = true;
    i2c.enable = true;

    graphics = {
      enable32Bit = true;
      extraPackages = [ pkgs.rocmPackages.clr.icd ];
    };
  };
}
