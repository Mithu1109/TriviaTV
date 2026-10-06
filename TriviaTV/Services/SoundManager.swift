//
//  SoundManager.swift
//  TriviaTV
//
//  Created for TriviaTV: Family Challenge
//

import Foundation
import AVFoundation
import AudioToolbox

final class SoundManager {
    static let shared = SoundManager()

    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var isMuted: Bool = false
    private var isConfigured: Bool = false
    private let audioQueue = DispatchQueue(label: "com.triviatv.soundmanager", qos: .userInteractive)

    // Precomputed sound buffers for instant zero-latency playback
    private var correctBuffer: AVAudioPCMBuffer?
    private var wrongBuffer: AVAudioPCMBuffer?
    private var victoryBuffer: AVAudioPCMBuffer?
    private var clickBuffer: AVAudioPCMBuffer?

    private init() {
        // Asynchronously initialize audio session and precompute sound buffers
        audioQueue.async { [weak self] in
            self?.setupAudio()
            self?.precomputeAudioBuffers()
        }
    }

    private func setupAudio() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)

            engine.attach(playerNode)
            let hardwareFormat = engine.mainMixerNode.outputFormat(forBus: 0)
            engine.connect(playerNode, to: engine.mainMixerNode, format: hardwareFormat)
            try engine.start()
            isConfigured = true
        } catch {
            print("SoundManager initialization note: \(error.localizedDescription)")
            isConfigured = false
        }
    }

    private func precomputeAudioBuffers() {
        let sampleRate: Double = 44100.0
        guard let standardFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else { return }

        correctBuffer = createHarmonicBuffer(frequencies: [523.25, 659.25, 783.99], duration: 0.14, format: standardFormat)
        wrongBuffer = createHarmonicBuffer(frequencies: [220.0, 196.0], duration: 0.20, format: standardFormat)
        victoryBuffer = createHarmonicBuffer(frequencies: [523.25, 659.25, 783.99, 1046.50], duration: 0.18, format: standardFormat)
        clickBuffer = createHarmonicBuffer(frequencies: [880.0], duration: 0.04, format: standardFormat)
    }

    private func createHarmonicBuffer(frequencies: [Double], duration: Double, format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let sampleRate = format.sampleRate
        let samplesPerNote = Int(sampleRate * duration)
        let totalSamples = samplesPerNote * frequencies.count

        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(totalSamples)) else {
            return nil
        }

        buffer.frameLength = AVAudioFrameCount(totalSamples)
        guard let channelData = buffer.floatChannelData?[0] else { return nil }

        var currentSample = 0
        for freq in frequencies {
            for i in 0..<samplesPerNote {
                if currentSample < totalSamples {
                    let envelope = sin(Double.pi * Double(i) / Double(samplesPerNote))
                    let value = Float(sin(2.0 * Double.pi * freq * Double(i) / sampleRate) * envelope * 0.35)
                    channelData[currentSample] = value
                    currentSample += 1
                }
            }
        }
        return buffer
    }

    func toggleMute() {
        isMuted.toggle()
    }

    var muted: Bool {
        isMuted
    }

    // MARK: - Sound Effects (Non-blocking, Asynchronous)
    func playCorrectSound() {
        guard !isMuted else { return }
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            self.playBuffer(self.correctBuffer)
        }
    }

    func playWrongSound() {
        guard !isMuted else { return }
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            self.playBuffer(self.wrongBuffer)
        }
    }

    func playTimerTick() {
        guard !isMuted else { return }
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            self.playBuffer(self.clickBuffer)
        }
    }

    func playVictorySound() {
        guard !isMuted else { return }
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            self.playBuffer(self.victoryBuffer)
        }
    }

    func playFocusClick() {
        guard !isMuted else { return }
        audioQueue.async { [weak self] in
            guard let self = self else { return }
            self.playBuffer(self.clickBuffer)
        }
    }

    private func playBuffer(_ buffer: AVAudioPCMBuffer?) {
        guard isConfigured, let buffer = buffer else { return }

        do {
            if !engine.isRunning {
                try engine.start()
            }
            playerNode.stop()
            playerNode.scheduleBuffer(buffer, completionHandler: nil)
            playerNode.play()
        } catch {
            print("Audio playback note: \(error.localizedDescription)")
        }
    }
}
