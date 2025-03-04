Extension { #name : #GtLlmTutorActionExample }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorActionExample >> inputDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Input';
		beRequired;
		priority: 2;
		accessor: #inputJson
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorActionExample >> outputDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Output';
		beRequired;
		priority: 2;
		accessor: #outputJson
]
