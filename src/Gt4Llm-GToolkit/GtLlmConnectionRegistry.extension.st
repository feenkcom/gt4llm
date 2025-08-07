Extension { #name : #GtLlmConnectionRegistry }

{ #category : #'*Gt4Llm-GToolkit' }
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

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmConnectionRegistry class >> gtConnectionsFor: aView [
	<gtClassView>
	^ aView forward
		title: 'Connections';
		priority: 10;
		object: [ self uniqueInstance ];
		view: #gtConnectionsFor:
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmConnectionRegistry class >> gtInstanceButtonFor: anAction [
	<gtClassAction>
	^ anAction button
		tooltip: 'Inspect unique instance';
		priority: 10;
		icon: BrGlamorousVectorIcons playinspect;
		action: [ :aButton | aButton phlow spawnObject: self uniqueInstance]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmConnectionRegistry >> knownConnectors [
	^ {GtLlmConnection new
			provider: GtOllamaProvider;
			label: 'Llama 3.2';
			model: 'llama3.2'.
		GtLlmConnection new
			provider: GtOllamaProvider;
			label: 'GPT OSS (Ollama 20b)';
			model: 'gpt-oss'.
		GtLlmConnection new
			provider: GtAnthropicProvider;
			label: 'Claude 3.7';
			model: 'claude-3-7-sonnet-20250219'.
		GtLlmConnection new
			provider: GtGeminiProvider;
			label: 'Gemini 2.5 Flash Preview';
			model: 'gemini-2.5-flash-preview-05-20'}
]
