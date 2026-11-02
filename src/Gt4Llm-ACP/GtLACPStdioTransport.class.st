"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPStdioTransport,
	#superclass : #GtLACPTransport,
	#instVars : [
		'agentProcess',
		'reader',
		'buffer',
		'writeLock'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #io }
GtLACPStdioTransport >> acceptChunk: aString [
 | index line |
 buffer := buffer, aString.
 [ (index := buffer indexOf: Character lf) > 0 ] whileTrue: [
  line := (buffer copyFrom: 1 to: index - 1) trimBoth.
  buffer := buffer copyFrom: index + 1 to: buffer size.
  line isEmpty ifFalse: [ connection receive: (STONJSON fromString: line) ] ]
]

{ #category : #accessing }
GtLACPStdioTransport >> agentProcess [
 ^ agentProcess
]

{ #category : #accessing }
GtLACPStdioTransport >> agentProcess: anObject [
 agentProcess := anObject
]

{ #category : #accessing }
GtLACPStdioTransport >> buffer [
 ^ buffer
]

{ #category : #accessing }
GtLACPStdioTransport >> buffer: anObject [
 buffer := anObject
]

{ #category : #lifecycle }
GtLACPStdioTransport >> close [
 state := #stopped.
 reader ifNotNil: [ reader == Processor activeProcess ifFalse: [ reader terminate ] ].
 agentProcess ifNotNil: #stop
]

{ #category : #views }
GtLACPStdioTransport >> gtProcessFor: aView [
 <gtView>
 agentProcess ifNil: [ ^ aView empty ].
 ^ aView forward title: 'Agent process'; priority: 0;
  object: [ agentProcess ]; view: #gtProcessFor:
]

{ #category : #accessing }
GtLACPStdioTransport >> initialize [
 super initialize.
 buffer := ''.
 writeLock := Mutex new
]

{ #category : #io }
GtLACPStdioTransport >> poll [
 agentProcess pollStderr.
 self acceptChunk: agentProcess pollStdout
]

{ #category : #accessing }
GtLACPStdioTransport >> reader [
 ^ reader
]

{ #category : #accessing }
GtLACPStdioTransport >> reader: anObject [
 reader := anObject
]

{ #category : #io }
GtLACPStdioTransport >> send: aDictionary [
 state = #running ifFalse: [ self error: 'Transport is not running' ].
 writeLock critical: [ agentProcess write: (STONJSON toString: aDictionary), String lf ]
]

{ #category : #lifecycle }
GtLACPStdioTransport >> start [
 agentProcess start.
 state := #running.
 reader := [
  [ [ state = #running ] whileTrue: [
    self poll.
    agentProcess isRunning ifFalse: [
     self poll.
     state := #closed.
     connection failed: 'Agent process exited' ].
    state = #running ifTrue: [ (Delay forMilliseconds: 10) wait ] ] ]
  on: Error do: [ :ex |
   state := #failed.
   connection failed: ex messageText.
   agentProcess stop ] ] forkAt: Processor userBackgroundPriority
]

{ #category : #accessing }
GtLACPStdioTransport >> writeLock [
 ^ writeLock
]

{ #category : #accessing }
GtLACPStdioTransport >> writeLock: anObject [
 writeLock := anObject
]
