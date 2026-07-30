Class {
	#name : #GtLOllamaProvider,
	#superclass : #GtLModelProvider,
	#classVars : [
		'IsConnectable'
	],
	#category : #'Gt4Llm-Ollama-Provider'
}

{ #category : #ui }
GtLOllamaProvider class >> gtToggleEnabledActionFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: (self isConnectable ifTrue: [ 'Disable' ] ifFalse: [ 'Enable' ]);
		icon: (self isConnectable
				ifTrue: [ BrGlamorousVectorIcons shutdown ]
				ifFalse: [ BrGlamorousVectorIcons play ]);
		action: [ :aButton | 
			self isConnectable
				ifTrue: [ self markNonconnectable.
					aButton icon: BrGlamorousVectorIcons play ]
				ifFalse: [ self markConnectable.
					aButton icon: BrGlamorousVectorIcons shutdown ] ]
]

{ #category : #initialization }
GtLOllamaProvider class >> initialize [

	IsConnectable := false
]

{ #category : #testing }
GtLOllamaProvider class >> isConnectable [
	^ IsConnectable
]

{ #category : #accessing }
GtLOllamaProvider class >> knownConnectors [
	<gtConnection>
	"If enabled, answer the list of known Ollama connectors.
	This makes a request to the Ollama server to retrieve the list of available models."
	| provider names |

	self isConnectable ifFalse: [ ^ #() ].

	provider := self new.
	names := [ provider availableModels keys ]
		on: ConnectionClosed
		do: [ :ex | #() ].
	^ names sorted collect: [ :name |
		GtLConnection new
			providerClass: self;
			label: name;
			model: name ]
]

{ #category : #api }
GtLOllamaProvider class >> markConnectable [
	IsConnectable = true ifTrue: [ ^ self ].
	
	IsConnectable := true.
	GtLOllamaProvider notifyProviderConnectabilityChanged
]

{ #category : #api }
GtLOllamaProvider class >> markNonconnectable [
	IsConnectable = false ifTrue: [ ^ self ].

	IsConnectable := false.
	GtLOllamaProvider notifyProviderConnectabilityChanged
]

{ #category : #accessing }
GtLOllamaProvider class >> providerName [
	^ 'Ollama'
]

{ #category : #views }
GtLOllamaProvider >> gtAvailableModelsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Available models';
		items: [ [ self availableModels ] value associations ];
		column: 'Key' text: [ :each | each key gtDisplayString ];
		column: 'Value' text: [ :each | each value gtDisplayString ];
		send: [ :each | each value ]
]

{ #category : #initialization }
GtLOllamaProvider >> initialize [
	| client |

	super initialize.
	client := GtLOllamaClient new.
	model 
		provider: self;
		client: client.
	model
		endpointAt: 'providerVersion' put: GtLOllamaVersionEndpoint new;
		endpointAt: 'modelDetails' put: GtLOllamaModelDetailsEndpoint new;
		endpointAt: 'availableModels' put: GtLOllamaAvailableModelsEndpoint new;
		endpointAt: 'runningModels' put: GtLOllamaPsEndpoint new;
		endpointAt: 'deleteModel' put: GtLOllamaDeleteEndpoint new;
		endpointAt: 'pullModel' put: GtLOllamaPullEndpoint new;
		endpointAt: 'createEmbeddings' put: GtLOllamaCreateEmbeddingsEndpoint new;
		endpointAt: 'createModel' put: GtLOllamaCreateModelEndpoint new.
	self responses.
]
