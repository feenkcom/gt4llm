"
I represent a session_meta payload from a rollout header. I provide the recorded directory and creation time without retaining conversation bodies.
"
Class {
	#name : #GtLACPCodexRolloutRecord,
	#superclass : #GtLACPCodexSessionRecord,
	#category : #'Gt4Llm-ACP-Session discovery'
}

{ #category : #accessing }
GtLACPCodexRolloutRecord >> agentKind [
	| subagent |
	self isGuardianReview ifTrue: [ ^ 'guardian review' ].
	subagent := self subagentSource.
	subagent = 'review' ifTrue: [ ^ 'review' ].
	subagent = 'compact' ifTrue: [ ^ 'compact' ].
	((subagent isKindOf: Dictionary) and: [ subagent includesKey: 'thread_spawn' ])
		ifTrue: [ ^ 'delegated agent' ].
	self isSubagent ifTrue: [ ^ 'subagent' ].
	self source isString ifTrue: [ ^ 'session' ].
	^ 'unknown'
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> agentNickname [
	^ metadata
		at: 'agent_nickname'
		ifAbsent: [ self spawnMetadata at: 'agent_nickname' ifAbsent: [ nil ] ]
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> agentPath [
	^ metadata
		at: 'agent_path'
		ifAbsent: [ self spawnMetadata at: 'agent_path' ifAbsent: [ nil ] ]
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> createdAt [
	^ self dateAt: 'timestamp'
]

{ #category : #metadata }
GtLACPCodexRolloutRecord >> dateKeys [
	^ #('timestamp')
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> directory [
	^ [ self validatedDirectory ] on: Error do: [ :error | nil ]
]

{ #category : #'gt - views' }
GtLACPCodexRolloutRecord >> gtOriginFor: aView [
	"What explicit metadata identifies this session's agent kind and parent?"

	<gtView>
	^ aView columnedList
		title: 'Agent origin';
		priority: -10;
		items: [ {'Kind' -> self agentKind.
				'Source' -> self source.
				'Thread source' -> self threadSource.
				'Parent thread' -> self parentThreadId.
				'Agent nickname' -> self agentNickname.
				'Agent path' -> self agentPath} ];
		column: 'Property' text: #key;
		column: 'Value'
			text: [ :entry | entry value ifNil: [ '(unknown)' ] ifNotNil: [ :value | value printString ] ];
		send: #value
]

{ #category : #testing }
GtLACPCodexRolloutRecord >> hasOrigin [
	^ self source notNil or: [ self threadSource notNil ]
]

{ #category : #initialization }
GtLACPCodexRolloutRecord >> initialize [
	super initialize.
	format := #codexRollout
]

{ #category : #testing }
GtLACPCodexRolloutRecord >> isGuardianReview [
	| subagent |
	self threadSource = 'guardian_review' ifTrue: [ ^ true ].
	subagent := self subagentSource.
	^ (subagent isKindOf: Dictionary)
		and: [ (subagent at: 'other' ifAbsent: [ nil ]) = 'guardian' ]
]

{ #category : #testing }
GtLACPCodexRolloutRecord >> isInternalAgent [
	^ #('guardian review' 'review' 'compact') includes: self agentKind
]

{ #category : #testing }
GtLACPCodexRolloutRecord >> isRolloutRecord [
	^ true
]

{ #category : #testing }
GtLACPCodexRolloutRecord >> isSubagent [
	^ self subagentSource notNil or: [ self isGuardianReview ]
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> issues [
	| result |
	result := super issues.
	[ self validatedDirectory ]
		on: Error
		do: [ :error | result add: (self newIssue: error messageText) ].
	^ result
]

{ #category : #metadata }
GtLACPCodexRolloutRecord >> metadataKeys [
	^ #('id' 'cwd' 'timestamp' 'originator' 'cli_version' 'source' 'thread_source' 'parent_thread_id' 'forked_from_id' 'agent_nickname' 'agent_path' 'agent_role')
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> parentThreadId [
	^ metadata
		at: 'parent_thread_id'
		ifAbsent: [ self spawnMetadata at: 'parent_thread_id' ifAbsent: [ nil ] ]
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> selectionReason [
	self directory ifNil: [ ^ 'Directory unavailable or invalid' ].
	self == session directoryRecord ifTrue: [ ^ 'Selected directory' ].
	self directory = session directory ifTrue: [ ^ 'Same directory' ].
	^ 'Conflicting directory; earlier source retained'
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> source [
	^ metadata at: 'source' ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> spawnMetadata [
	| subagent |
	subagent := self subagentSource.
	^ (subagent isKindOf: Dictionary)
		ifTrue: [ subagent at: 'thread_spawn' ifAbsent: [ Dictionary new ] ]
		ifFalse: [ Dictionary new ]
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> subagentSource [
	| source |
	source := self source.
	^ (source isKindOf: Dictionary)
		ifTrue: [ source at: 'subagent' ifAbsent: [ nil ] ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
GtLACPCodexRolloutRecord >> threadSource [
	^ metadata at: 'thread_source' ifAbsent: [ nil ]
]

{ #category : #private }
GtLACPCodexRolloutRecord >> validatedDirectory [
	| path |
	path := metadata at: 'cwd' ifAbsent: [ ^ nil ].
	path isString ifFalse: [ self error: 'Project directory must be a string' ].
	path ifEmpty: [ self error: 'Project directory must not be empty' ].
	path := path asFileReference.
	path isAbsolute
		ifFalse: [ self error: 'Recorded project directory must be absolute' ].
	^ path
]
