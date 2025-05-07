Class {
	#name : #GtLlmConnectionRegistry,
	#superclass : #Object,
	#traits : 'TGtUniqueInstance',
	#classTraits : 'TGtUniqueInstance classTrait',
	#instVars : [
		'connections',
		'defaultConnection'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> addConnection: aConnection [
	(connections includes: aConnection) ifTrue: [ ^ self ].
	connections add: aConnection
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> connectableConnections [
	^ self connections select: [ :aConnection | aConnection isConnectable ]
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> connectionFor: aProvider [
	^ connections
		detect: [ :aConnection | 
			aConnection provider = aProvider class
				and: [ aConnection model = aProvider model ] ]
		ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> connectionFor: aProviderName andModel: aModelName [
	^ connections
		detect: [ :aConnection | aConnection providerName = aProviderName and: [ aConnection model = aModelName ] ]
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> connections [
	^ connections
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> defaultConnection [
	^ defaultConnection ifNil: [ connections first ]
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> defaultConnection: aConnection [
	defaultConnection := aConnection.

	(connections includes: aConnection) ifFalse: [ connections add: aConnection ]
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> gtConnectionsFor: aView [
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
					ifFalse: [ BrGlamorousVectorIcons noIcon ] ] width: 60;
		column: 'Connectable'
			icon: [ :aConnection | 
				aConnection isConnectable
					ifTrue: [ BrGlamorousVectorIcons accept ]
					ifFalse: [ BrGlamorousVectorIcons noIcon ] ] width: 90
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> hasConnectableConnection [
	^ self connectableConnections isNotEmpty
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> initialize [
	super initialize.
	
	connections := OrderedCollection withAll: self knownConnectors.
	self defaultConnection: self standardDefaultConnection
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> knownConnectors [
	^ {GtLlmConnection new
			provider: GtOllamaProvider;
			label: 'Llama 3.1';
			model: 'llama3.1'.
		GtLlmConnection new
			provider: GtAnthropicProvider;
			label: 'Claude 3.7';
			model: 'claude-3-7-sonnet-20250219'}
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> standardDefaultConnection [
	^ GtLlmConnection new
		provider: GtOpenAIResponseProvider;
		label: 'GPT 4.1';
		model: 'gpt-4.1'
]
