Feature: Out of memory errors

# Due to the combination of BrowserStack's behaviour when resetting the app and the way that our OOM detection works,
# the I relaunch the app steps are currently sufficient to trigger the OOM mechanism. However, these tests may not
# behave in the same way on local devices, device farms other that BrowserStack, or if we change that OOM detection works.

  Background:
    Given I clear all persistent data

  Scenario: Out of memory errors are enabled when loading configuration
    When I run "OOMLoadScenario"
    And I wait to receive 2 requests

    Then the request is valid for the session reporting API version "1.0" for the "iOS Bugsnag Notifier" notifier
    And I discard the oldest request

    And the event "unhandled" is false
    And the exception "message" equals "OOMLoadScenario"
    And the event has a "manual" breadcrumb named "OOMLoadScenarioBreadcrumb"
    And I discard the oldest request

    When I relaunch the app
    And I configure Bugsnag for "OOMLoadScenario"
    And I wait to receive 2 requests

    Then the request is valid for the session reporting API version "1.0" for the "iOS Bugsnag Notifier" notifier
    And I discard the oldest request

    And the error is an OOM event

    # Ensure the basic data from OOMs are present
    And the event "device.jailbroken" is false
    And the event "metaData.device.batteryLevel" is not null
    And the event "metaData.device.charging" is not null
    And the event "metaData.device.orientation" is not null
    And the event "metaData.device.timezone" is not null
    And the event "metaData.device.simulator" is false
    And the event "metaData.device.wordSize" is not null
    And the event "app.id" equals "com.bugsnag.iOSTestApp"
    And the event "metaData.app.name" equals "iOSTestApp"
    And the event "app.inForeground" is true
    And the event "app.type" equals "iOS"
    And the event "app.bundleVersion" is not null
    And the event "app.dsymUUIDs" is not null
    And the event "app.version" is not null
    And the event "device.manufacturer" equals "Apple"
    And the event "device.runtimeVersions" is not null
    And the event "device.totalMemory" is not null
    And the event "metaData.custom.bar" equals "foo"
    And the event "session.id" is not null
    And the event "session.startedAt" is not null
    And the event "session.events.handled" equals 1
    And the event "session.events.unhandled" equals 1
    And the event "unhandled" is true
    And the event "user.id" equals "foobar"
    And the event "user.email" equals "foobar@example.com"
    And the event "user.name" equals "Foo Bar"

    # Ensure breadcrumbs are carried over
    And the event has a "manual" breadcrumb named "OOMLoadScenarioBreadcrumb"
    And the event has a "error" breadcrumb named "OOMLoadScenario"

  Scenario: Out of memory errors are disabled by AutoDetectErrors
    When I run "OOMAutoDetectErrorsScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "unhandled" is false
    And the exception "message" equals "OOMAutoDetectErrorsScenario"
    And I discard the oldest request

    And I relaunch the app
    And I run "OOMAutoDetectErrorsScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "unhandled" is false
    And the exception "message" equals "OOMAutoDetectErrorsScenario"

  Scenario: Out of memory errors are disabled by EnabledErrorTypes
    When I run "OOMEnabledErrorTypesScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "unhandled" is false
    And the exception "message" equals "OOMEnabledErrorTypesScenario"
    And I discard the oldest request

    And I relaunch the app
    And I run "OOMEnabledErrorTypesScenario"
    And I wait to receive a request
    Then the request is valid for the error reporting API version "4.0" for the "iOS Bugsnag Notifier" notifier
    And the event "unhandled" is false
    And the exception "message" equals "OOMEnabledErrorTypesScenario"
