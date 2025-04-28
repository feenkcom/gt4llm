Extension { #name : #GtLlmAssistantActionExample }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantActionExample >> inputDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Input';
		beRequired;
		priority: 2;
		accessor: #inputJson
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantActionExample >> outputDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Output';
		beRequired;
		priority: 2;
		accessor: #outputJson
]
