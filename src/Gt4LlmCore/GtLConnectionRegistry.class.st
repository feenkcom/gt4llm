Class {
	#name : #GtLConnectionRegistry,
	#superclass : #Object,
	#instVars : [
		'connections',
		'defaultConnection'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLConnectionRegistry class >> cleanUniqueInstance [
	uniqueInstance ifNotNil: [ :anInstance | 
		self onRemoveUniqueInstance: anInstance ].
	uniqueInstance := nil.
]

{ #category : #cleaning }
GtLConnectionRegistry class >> cleanUp [
	self cleanUniqueInstance
]

{ #category : #accessing }
GtLConnectionRegistry class >> default [
	^ self uniqueInstance
]

{ #category : #'gt - extensions' }
GtLConnectionRegistry class >> gtConnectionsFor: aView [
	<gtClassView>
	^ aView forward
		title: 'Connections';
		priority: 10;
		object: [ self uniqueInstance ];
		view: #gtConnectionsFor:
]

{ #category : #'gt - extensions' }
GtLConnectionRegistry class >> gtInstanceButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Inspect unique instance';
		priority: 10;
		icon: BrGlamorousVectorIcons playinspect;
		action: [ :aButton | aButton phlow spawnObject: self uniqueInstance]
]

{ #category : #testing }
GtLConnectionRegistry class >> hasUniqueInstance [

	^ uniqueInstance isNotNil
]

{ #category : #accessing }
GtLConnectionRegistry class >> instance [
	<gtExample>
	^ self uniqueInstance
]

{ #category : #'private - hooks' }
GtLConnectionRegistry class >> onRemoveUniqueInstance: anInstance [
	"Classes may perform some activities on a singleton that is about to be released"
]

{ #category : #accessing }
GtLConnectionRegistry class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #adding }
GtLConnectionRegistry >> addConnection: aConnection [
	(connections includes: aConnection) ifTrue: [ ^ self ].
	connections add: aConnection
]

{ #category : #cleanup }
GtLConnectionRegistry >> clearConnections [
	connections removeAll
]

{ #category : #accessing }
GtLConnectionRegistry >> connectableConnections [
	^ self connections select: [ :aConnection | aConnection isConnectable ]
]

{ #category : #utils }
GtLConnectionRegistry >> connectionFor: aProvider [
	^ connections
		detect: [ :aConnection | 
			aConnection providerClass = aProvider class
				and: [ aConnection model = aProvider modelName ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
GtLConnectionRegistry >> connections [
	^ connections
]

{ #category : #accessing }
GtLConnectionRegistry >> defaultConnection [
	^ (defaultConnection isNil or: [ defaultConnection isConnectable not ])
		ifTrue: [ self connectableConnections
				ifEmpty: [ nil ]
				ifNotEmpty: [ :aConnectionsList | aConnectionsList first ] ]
		ifFalse: [ defaultConnection ]
]

{ #category : #accessing }
GtLConnectionRegistry >> defaultConnection: aConnection [
	defaultConnection := aConnection.

	(connections includes: aConnection) ifFalse: [ connections add: aConnection ]
]

{ #category : #'gt - extensions' }
GtLConnectionRegistry >> gtConnectionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Connections';
		priority: 1;
		items: [ connections ];
		column: 'Label' text: #label;
		column: 'Provider' text: #providerName;
		column: 'Model' text: #model;
		column: 'Default'
			icon: [ :aConnection | 
				aConnection = self defaultConnection
					ifTrue: [ BrGlamorousVectorIcons accept ]
					ifFalse: [ BrGlamorousVectorIcons noIcon ] ]
			width: 60;
		column: 'Connectable'
			icon: [ :aConnection | 
				aConnection isConnectable
					ifTrue: [ BrGlamorousVectorIcons accept ]
					ifFalse: [ BrGlamorousVectorIcons noIcon ] ]
			width: 90;
		contextItemLabel: 'Make default'
			action: [ :anItem :aConnection | 
				self defaultConnection: aConnection.
				anItem anchor phlow fireViewUpdateWish ]
]

{ #category : #testing }
GtLConnectionRegistry >> hasConnectableConnection [
	^ self connectableConnections isNotEmpty
]

{ #category : #testing }
GtLConnectionRegistry >> hasConnectableDefaultConnection [
	^ self defaultConnection isNotNil and: [ self defaultConnection isConnectable ]
]

{ #category : #initialization }
GtLConnectionRegistry >> initialize [
	super initialize.
	
	connections := OrderedCollection withAll: self knownConnectors.
	self defaultConnection: self standardDefaultConnection
]

{ #category : #accessing }
GtLConnectionRegistry >> knownConnectors [
	^ {"GtLlmConnection new
			providerClass: GtOllamaProvider;
			label: 'Llama 3.2';
			model: 'llama3.2'.
		GtLlmConnection new
			providerClass: GtOllamaProvider;
			label: 'GPT OSS (Ollama 20b)';
			model: 'gpt-oss'."
		"GtLConnection new
			providerClass: GtLAnthropicProvider;
			label: 'Claude Opus 4.5';
			model: 'claude-opus-4-5-20251101'."
		"GtLlmConnection new
			providerClass: GtGeminiProvider;
			label: 'Gemini 3.0 Pro Preview';
			model: 'gemini-3-pro-preview'"}
]

{ #category : #utils }
GtLConnectionRegistry >> labelForModel: aModel [
	^ connections
		detect: [ :aConnection | aConnection model = aModel ]
		ifFound: [ :aConnection | aConnection label ifNil: [ aModel ] ]
		ifNone: [ aModel ]
]

{ #category : #accessing }
GtLConnectionRegistry >> standardDefaultConnection [
	^ GtLConnection new
		providerClass: GtLOpenAIProvider;
		label: 'GPT 5.2 Codex';
		model: 'gpt-5.2-codex'";
		addOption: 'isStreaming' withValue: false"
]
