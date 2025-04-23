 { config, pkgs, ... }:
 {


  config.virtualisation.oci-containers.containers = {
    libregrammar = {
      image = "ghcr.io/c4illin/convertx";
      ports = ["3033:3000"];
      volumes = [
        "/mnt/media/convertx:/app/data"
      ];
      environment = {
        AUTO_DELETE_EVERY_N_HOURS = 24;
        ACCOUNT_REGISTRATION = false;
        ALLOW_UNAUTHENTICATED = false;
        JWT_SECRET = "b7ba8dfd0f1d5f3ffcfeacbbd155275b79bd34fe173e0c9438c0e7a649af656eb5f017c32e5fde51e81508a796b8467ce3e7661c5f6406a342ae54fe530b93ae6d1964eda742aee6ffc40dde36f1e5ced08f1f580e8797a93ead57150821dbec891937250e75bb313403d7a09616f914437e492a400c04a4e8a56521ffc8ac96c1bd2d4bbee7b32b1763606010b0a82569f6a26441baafe7993e784589e17393484570fb77d7f46c176ec90becde31d6292eeaf641fc9263c208d05ceef92b6d514f990167e8d796f96e1dbd72df1c8b0391730d24b12b449f5894e3323f88d9d6c634bfae363887e80fbdc59f1c6cf091319bb15360dab8747405d696e831bf";
      };
      user = "root";
    };
  };

 }
