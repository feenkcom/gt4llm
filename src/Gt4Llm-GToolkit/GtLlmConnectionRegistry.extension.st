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
					ifFalse: [ BrGlamorousVectorIcons noIcon ] ] width: 60;
		column: 'Connectable'
			icon: [ :aConnection | 
				aConnection isConnectable
					ifTrue: [ BrGlamorousVectorIcons accept ]
					ifFalse: [ BrGlamorousVectorIcons noIcon ] ] width: 90
]

{ #category : #'*Gt4Llm-GToolkit' }
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
