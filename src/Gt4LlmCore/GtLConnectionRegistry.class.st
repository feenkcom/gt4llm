Class {
	#name : #GtLConnectionRegistry,
	#superclass : #Object,
	#instVars : [
		'connections',
		'defaultConnection',
		'announcer'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Gt4LlmCore-Core'
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
	| allConnections |
	connections
		lock: [ :aCollection | 
			(aCollection includes: aConnection) ifTrue: [ ^ self ].
			aCollection add: aConnection.
			allConnections := aCollection copy ].

	announcer
		announce: (GtLConnectionRegistryConnectionAdded new
				connectionRegistry: self;
				connection: aConnection;
				connections: allConnections)
]

{ #category : #accessing }
GtLConnectionRegistry >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #cleanup }
GtLConnectionRegistry >> clearConnections [
	connections
		lock: [ :aCollection | 
			aCollection removeAll.
			defaultConnection := nil ].

	announcer
		announce: (GtLConnectionRegistryConnectionsChanged new
				connectionRegistry: self;
				connections: #())
]

{ #category : #accessing }
GtLConnectionRegistry >> connectableConnections [
	^ self connections select: [ :aConnection | aConnection isConnectable ]
]

{ #category : #utils }
GtLConnectionRegistry >> connectionFor: aProvider [
	^ connections
		lock: [ :aCollection | 
			aCollection
				detect: [ :aConnection | 
					aConnection providerClass = aProvider class
						and: [ aConnection model = aProvider modelName ] ]
				ifNone: [ nil ] ]
]

{ #category : #accessing }
GtLConnectionRegistry >> connections [
	^ connections value
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
	connections
		lock: [ :aCollection | 
			defaultConnection := aConnection.
			self addConnection: aConnection ]
]

{ #category : #'gt - extensions' }
GtLConnectionRegistry >> gtConnectionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Connections';
		priority: 1;
		items: [ connections ifNotNil: #value ];
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
				anItem anchor phlow fireViewUpdateWish ];
		updateWhen: GtLConnectionRegistryAnnouncement in: [ announcer ]
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
	
	announcer := Announcer new.
	connections := AsyncMutex for: OrderedCollection new.
	
	self updateConnections.
]

{ #category : #accessing }
GtLConnectionRegistry >> knownConnectors [
	^ {
		GtLConnection new
			providerClass: GtLAnthropicProvider;
			label: 'Claude Opus 4.5';
			model: 'claude-opus-4-5'.
		GtLConnection new
			providerClass: GtLAnthropicProvider;
			label: 'Claude Opus 4.6';
			model: 'claude-opus-4-6'.
		GtLConnection new
			providerClass: GtLAnthropicProvider;
			label: 'Claude Opus 4.7';
			model: 'claude-opus-4-7'.
		GtLConnection new
			providerClass: GtLAnthropicProvider;
			label: 'Claude Opus 4.8';
			model: 'claude-opus-4-8'.
		GtLConnection new
			providerClass: GtLAnthropicProvider;
			label: 'Claude Fable 5';
			model: 'claude-fable-5'.
		GtLConnection new
			providerClass: GtLOpenAIProvider;
			label: 'GPT 5.2';
			model: 'gpt-5.2'.
		GtLConnection new
			providerClass: GtLOpenAIProvider;
			label: 'GPT 5.2 Codex';
			model: 'gpt-5.2-codex'.
		GtLConnection new
			providerClass: GtLOpenAIProvider;
			label: 'GPT 5.3 Codex';
			model: 'gpt-5.3-codex'.
		GtLConnection new
			providerClass: GtLOpenAIProvider;
			label: 'GPT 5.3';
			model: 'gpt-5.3'.
		GtLConnection new
			providerClass: GtLOpenAIProvider;
			label: 'GPT 5.5';
			model: 'gpt-5.5'.
		},
		self knownOllamaConnectors
]

{ #category : #'private - accessing' }
GtLConnectionRegistry >> knownOllamaConnectors [
	"If enabled, answer the list of known Ollama connectors.
	This makes a request to the Ollama server to retrieve the list of available models."
	| provider names |

	GtLOllamaProvider isConnectable ifFalse: [ ^ #() ].

	provider := GtLModelFactory new ollama provider.
	names := [ provider availableModels keys ]
		on: ConnectionClosed
		do: [ :ex | #() ].
	^ names sorted collect: [ :name |
		GtLConnection new
			providerClass: GtLOllamaProvider;
			label: name;
			model: name. ]
]

{ #category : #utils }
GtLConnectionRegistry >> labelForModel: aModel [
	^ connections
		lock: [ :aCollection | 
			aCollection
				detect: [ :aConnection | aConnection model = aModel ]
				ifFound: [ :aConnection | aConnection label ifNil: [ aModel ] ]
				ifNone: [ aModel ] ]
]

{ #category : #accessing }
GtLConnectionRegistry >> standardDefaultConnection [
	^ GtLConnection new
		providerClass: GtLOpenAIProvider;
		label: 'GPT 5.4';
		model: 'gpt-5.4'
]

{ #category : #initialization }
GtLConnectionRegistry >> updateConnections [
	"Update the list of connections"

	| newConnections |
	newConnections := #().
	connections
		lock: [ :aCollection | 
			aCollection
				removeAll;
				addAll: self knownConnectors.
			self defaultConnection: self standardDefaultConnection.

			newConnections := aCollection copy ].

	announcer
		announce: (GtLConnectionRegistryConnectionsChanged new
				connectionRegistry: self;
				connections: newConnections)
]
