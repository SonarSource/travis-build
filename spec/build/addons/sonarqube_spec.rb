require 'spec_helper'

describe Travis::Build::Addons::Sonarqube, :sexp do
  let(:script) { stub('script') }
  let(:config) { :true }
  let(:data)   { payload_for(:push, :ruby, config: { addons: { sonarqube: config } }) }
  let(:sh)     { Travis::Shell::Builder.new }
  let(:addon)  { described_class.new(script, sh, Travis::Build::Data.new(data), config) }
  subject      { sh.to_sexp }
  before       { 
    addon.after_header
    addon.before_before_script 
  }

  it_behaves_like 'compiled script' do
    let(:code) { ['install_sonar_scanner', 'curl -sSLo $HOME/.sonar/sonar-scanner.zip'] }
  end

  describe 'scanner installation' do
    it { should include_sexp [:cmd, 'install_sonar_scanner', echo: true, timing: true] }

    it { should include_sexp [:export, ['SONAR_SCANNER_HOME', '$HOME/.sonar/sonar-scanner-2.6'], {:echo=>true}] }
    it { should include_sexp [:export, ['SONAR_SCANNER_OPTS', "\"$SONAR_SCANNER_OPTS -Dsonar.host.url=https://dory.sonarsource.com/sonarqube\""], {:echo=>true}] }
    it { should include_sexp [:export, ['MAVEN_OPTS', "\"$MAVEN_OPTS -Dsonar.host.url=https://dory.sonarsource.com/sonarqube\""], {:echo=>true}] }
  end
end

