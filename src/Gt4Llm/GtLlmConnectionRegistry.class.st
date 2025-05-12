Class {
	#name : #GtLlmConnectionRegistry,
	#superclass : #Object,
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
GtLlmConnectionRegistry class >> cleanUniqueInstance [
	uniqueInstance ifNotNil: [ :anInstance | 
		self onRemoveUniqueInstance: anInstance ].
	uniqueInstance := nil.
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry class >> cleanUp [
	self cleanUniqueInstance
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry class >> default [
	^ self uniqueInstance
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry class >> hasUniqueInstance [

	^ uniqueInstance isNotNil
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry class >> instance [
	<gtExample>
	^ self uniqueInstance
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry class >> new [
	^ self basicNew initialize
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry class >> onRemoveUniqueInstance: anInstance [
	"Classes may perform some activities on a singleton that is about to be released"
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> addConnection: aConnection [
	(connections includes: aConnection) ifTrue: [ ^ self ].
	connections add: aConnection
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> clearConnections [
	connections removeAll
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
				and: [ aConnection model = aProvider modelName ] ]
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
GtLlmConnectionRegistry >> hasConnectableConnection [
	^ self connectableConnections isNotEmpty
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> hasConnectableDefaultConnection [
	^ self defaultConnection isConnectable
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> initialize [
	super initialize.
	
	connections := OrderedCollection withAll: self knownConnectors.
	self defaultConnection: self standardDefaultConnection
]

{ #category : #'as yet unclassified' }
GtLlmConnectionRegistry >> standardDefaultConnection [
	^ GtLlmConnection new
		provider: GtOpenAIResponseProvider;
		label: 'GPT 4.1';
		model: 'gpt-4.1'
]
