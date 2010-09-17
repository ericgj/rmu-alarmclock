## Unit tests for the Eventmachine implementation

This folder contains unit tests of client and server components under lib/em/lib.

These tests either do not require an EM reactor to be running at all, or stub the reactor using methods in `shared/em_spec_helper`.
