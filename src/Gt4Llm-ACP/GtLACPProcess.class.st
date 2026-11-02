"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPProcess,
	#superclass : #GtLACPObject,
	#instVars : [
		'configuration',
		'directory',
		'nativeProcess',
		'stdoutBuffer',
		'stderrBuffer',
		'stderr',
		'exitStatus'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPProcess >> configuration [
 ^ configuration
]

{ #category : #accessing }
GtLACPProcess >> configuration: anObject [
 configuration := anObject
]

{ #category : #accessing }
GtLACPProcess >> directory [
 ^ directory
]

{ #category : #accessing }
GtLACPProcess >> directory: anObject [
 directory := anObject
]

{ #category : #accessing }
GtLACPProcess >> exitStatus [
 ^ exitStatus
]

{ #category : #accessing }
GtLACPProcess >> exitStatus: anObject [
 exitStatus := anObject
]

{ #category : #views }
GtLACPProcess >> gtProcessFor: aView [
 <gtView>
 ^ aView columnedList title: 'Process'; priority: 0;
  items: [ {
   'Executable' -> (configuration ifNotNil: #executable).
   'Launch directory' -> directory.
   'Process ID' -> self processId.
   'Running' -> self isRunning.
   'Exit status' -> exitStatus } ];
  column: 'Process' text: #key;
  column: 'Value' text: [ :entry | entry value printString ];
  send: #value;
  actionUpdateButtonTooltip: 'Refresh process diagnostics'
]

{ #category : #views }
GtLACPProcess >> gtStderrFor: aView [
 <gtView>
 ^ aView textEditor title: 'stderr'; priority: 20; text: [ stderr ]; actionUpdateButtonTooltip: 'Refresh stderr'
]

{ #category : #accessing }
GtLACPProcess >> initialize [
 super initialize.
 stderr := ''
]

{ #category : #accessing }
GtLACPProcess >> isRunning [
 nativeProcess ifNil: [ ^ false ].
 exitStatus := nativeProcess tryWait.
 ^ exitStatus isNil
]

{ #category : #accessing }
GtLACPProcess >> nativeProcess [
 ^ nativeProcess
]

{ #category : #accessing }
GtLACPProcess >> nativeProcess: anObject [
 nativeProcess := anObject
]

{ #category : #io }
GtLACPProcess >> pollStderr [
 stderr := stderr, stderrBuffer pollString
]

{ #category : #io }
GtLACPProcess >> pollStdout [
 ^ stdoutBuffer pollString
]

{ #category : #accessing }
GtLACPProcess >> processId [
 ^ nativeProcess ifNotNil: #id
]

{ #category : #lifecycle }
GtLACPProcess >> start [
 | builder |
 nativeProcess ifNotNil: [ self error: 'Process already started' ].
 configuration validate.
 builder := GtExternalProcessBuilder new
  command: configuration executable;
  arguments: configuration arguments;
  workingDirectory: directory fullName;
  pipeStdin; pipeStdout; pipeStderr; yourself.
 configuration environment keysAndValuesDo: [ :key :value | builder env: key value: value ].
 nativeProcess := builder spawn.
 nativeProcess terminateOnShutdown.
 stdoutBuffer := nativeProcess asynchronousStdout.
 stderrBuffer := nativeProcess asynchronousStderr
]

{ #category : #accessing }
GtLACPProcess >> stderr [
 ^ stderr
]

{ #category : #accessing }
GtLACPProcess >> stderr: anObject [
 stderr := anObject
]

{ #category : #accessing }
GtLACPProcess >> stderrBuffer [
 ^ stderrBuffer
]

{ #category : #accessing }
GtLACPProcess >> stderrBuffer: anObject [
 stderrBuffer := anObject
]

{ #category : #accessing }
GtLACPProcess >> stdoutBuffer [
 ^ stdoutBuffer
]

{ #category : #accessing }
GtLACPProcess >> stdoutBuffer: anObject [
 stdoutBuffer := anObject
]

{ #category : #lifecycle }
GtLACPProcess >> stop [
 | deadline |
 nativeProcess ifNil: [ ^ self ].
 nativeProcess stdin close.
 deadline := Time millisecondClockValue + 2000.
 [ self isRunning and: [ Time millisecondClockValue < deadline ] ]
  whileTrue: [ (Delay forMilliseconds: 10) wait ].
 self isRunning ifTrue: [
  nativeProcess terminate.
  (Delay forMilliseconds: 100) wait.
  self isRunning ifTrue: [ nativeProcess kill ] ].
 exitStatus := nativeProcess wait.
 stdoutBuffer ifNotNil: [ stdoutBuffer releaseSemaphoreSignaller ].
 stderrBuffer ifNotNil: [ stderrBuffer releaseSemaphoreSignaller ]
]

{ #category : #io }
GtLACPProcess >> write: aString [
 nativeProcess stdin nextPutAll: aString
]
