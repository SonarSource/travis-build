require 'travis/build/addons/base'

module Travis
  module Build
    class Addons
      class Sonarqube < Base
        SUPER_USER_SAFE = true
        TEMPLATES_PATH = File.expand_path('templates', __FILE__.sub('.rb', ''))
        DEFAULT_SQ_HOST_URL = "https://nemo.sonarqube.org"
        SCANNER_CLI_VERSION = "2.6.1"

        def after_header
          @scanner_home = "$HOME/.sonarscanner"
          sh.raw template('sonarqube.sh', home: @scanner_home, version: SCANNER_CLI_VERSION )
        end

        def before_before_script
          sh.fold 'sonarqube.install' do
            sh.echo "Preparing SonarQube Scanner", echo: false, ansi: :yellow
            sh.cmd 'install_sonar_scanner', assert: false, echo: true, timing: true

            sh.export 'SONAR_SCANNER_HOME', "#{@scanner_home}/sonar-scanner-#{SCANNER_CLI_VERSION}", echo: true
            sh.export 'SONAR_SCANNER_OPTS', "\"$SONAR_SCANNER_OPTS -Dsonar.host.url=#{DEFAULT_SQ_HOST_URL}\"", echo: true
            sh.export 'MAVEN_OPTS', "\"$MAVEN_OPTS -Dsonar.host.url=#{DEFAULT_SQ_HOST_URL}\"", echo: true
            sh.export 'GRADLE_OPTS', "\"$GRADLE_OPTS -Dsonar.host.url=#{DEFAULT_SQ_HOST_URL}\"", echo: true
          end
        end
      end
    end
  end
end
