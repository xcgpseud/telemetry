Context = {
    SpeedTest = {},
    DoNotShow = {
        DeleteGroup = false,
    },
}

function Context:GetSpeedTestContext()
    return self.SpeedTest
end

function Context:ResetSpeedTestContext()
    local speedTest = {
        IsRunning = false,
        IsAccelerating = false,
        IsBraking = false,
        IsFinished = false,
        TestType = TestType.WithoutUpgrades,

        Accelerating = {
            WhenStartedMoving = -1,
            SpeedsRecorded = {},
            CurrentSpeedKey = -1,
            PassedFinalSpeedCheck = false,
            WhenReachedMaxSpeed = -1,
            MaxSpeedReached = -1,
        },
        Braking = {
            WhenStartedBraking = -1,
            SpeedsRecorded = {},
            CurrentSpeedKey = -1,
            PassedFinalSpeedCheck = false,
            WhenStopped = -1,
        }
    }

    for key, speed in ipairs(Config.SpeedTest.SpeedsToRecord) do
        speedTest.Accelerating.SpeedsRecorded[key] = {
            SpeedInMph = speed,
            TimestampWhenReached = -1,
        }
        speedTest.Braking.SpeedsRecorded[key] = {
            SpeedInMph = speed,
            TimestampWhenReached = -1,
        }
    end

    self.SpeedTest = speedTest
end

Context:ResetSpeedTestContext()