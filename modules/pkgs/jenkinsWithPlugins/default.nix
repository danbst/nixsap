{ pkgs, lib, stdenv, fetchurl }:

/*

  This is a function that should return a list of plugins to be included in the WAR.
  Example: pkgs.jenkinsWithPlugins (plugins: [ plugins.BlameSubversion ... ])

  Non-optional dependencies, if any, are automatically added. Optional
  dependencies are ignored, you have to add them explicitly.

*/

pluginsFunc:

let

  inherit (builtins) fromJSON readFile;
  fromBase64 = import ./fromBase64.nix;

  inherit (lib)
    concatMapStrings filter flatten unique ;

  updateCenter = fromJSON (readFile pkgs.jenkinsUpdateCenter);

  core = with updateCenter.core; fetchurl {
    inherit url;
    name = "jenkins-${version}-core.war";
    sha1 = fromBase64 sha1;
  };

  plugin = p: fetchurl {
    inherit (p) url;
    sha1 = fromBase64 p.sha1;
    name = "jenkins-plugin-${p.name}-${p.version}.hpi";
  };

  pluginsPack = list: stdenv.mkDerivation {
    name = "jenkins-plugins-pack";
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out
      ${concatMapStrings (p: ''
        ln -svf "${plugin p}" "$out/${p.name}.hpi"
      '') list}
    '';
  };

  neededPlugins =
    let
      rootPlugins = map (p: p.name) (pluginsFunc updateCenter.plugins);
      directDeps = names:
        let
          pluginDeps = p: map (d: d.name) (filter (d: ! d.optional) p.dependencies);
          deps = map (n: pluginDeps updateCenter.plugins.${n}) names;
        in flatten deps;

      getDepsRecursive = names:
        if names == [] then []
        else names ++ getDepsRecursive (directDeps names)
        ;
      all = unique ( getDepsRecursive rootPlugins );
    in map (n: updateCenter.plugins.${n}) all;

  pack =  stdenv.mkDerivation rec {
    name = "jenkins-${updateCenter.core.version}+plugins.war";

    # https://wiki.jenkins-ci.org/display/JENKINS/Bundling+plugins+with+Jenkins
    build-xml = pkgs.writeXML "jenkins.build.xml"
      ''
      <?xml version="1.0" encoding="UTF-8"?>
      <project basedir="." name="Jenkins-Bundle">
        <target name="bundle" description="Merge plugins into jenkins.war">
          <zip destfile="jenkins.war" level="9">
            <zipfileset src="${core}" />
            <zipfileset dir="${pluginsPack neededPlugins}" prefix="WEB-INF/plugins" />
          </zip>
        </target>
      </project>
      '';

    meta = with stdenv.lib; {
      description = "An extendable open source continuous integration server";
      homepage = http://jenkins-ci.org;
      license = licenses.mit;
      platforms = platforms.all;
    };

    buildInputs = with pkgs; [ ant jdk ];

    phases = [ "buildPhase" "installPhase" ];
    buildPhase = ''
      ln -sf ${build-xml} build.xml
      ant bundle
    '';
    installPhase = "cp jenkins.war $out";
  };

in if neededPlugins == [] then core else pack

