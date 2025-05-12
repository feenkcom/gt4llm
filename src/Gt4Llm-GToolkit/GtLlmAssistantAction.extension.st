Extension { #name : #GtLlmAssistantAction }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantAction >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Description';
		beRequired;
		priority: 3;
		accessor: #description
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantAction >> examplesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Examples';
		priority: 5;
		accessor: #examples;
		classes: {GtLlmAssistantActionExample};
		beModifiable;
		blocItemStencil: [ :anItemViewModel :anItemIndex | 
			anItemViewModel asElement
				fitContent;
				border: (BlBorder paint: BrGlamorousColors disabledButtonBorderColor width: 1);
				margin: (BlInsets
						top: 0
						right: 5
						bottom: 5
						left: 0);
				padding: (BlInsets all: 5);
				background: Color white ];
		  newItemStencil: [ GtLlmAssistantActionExample new ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantAction >> gtDefinitionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Definition';
		priority: 1;
		actionButtonIcon: BrGlamorousVectorIcons browse
			tooltip: 'Browse method'
			action: [ self definingMethod gtBrowse ];
		stencil: [ | coder |
			coder := GtPharoMethodCoder forMethod: self definingMethod.
			coder addOns addStyler: (GtLlmAssistantFormatStyler new assistant: self assistant).
			coder asExpandedOnlyElement vFitContentLimited ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantAction >> initializeMethod [
	^ (thisContext stack at: 4) blocDefiningMethod
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantAction >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name';
		beRequired;
		priority: 1;
		accessor: #name
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantAction >> priorityDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Priority';
		priority: 2;
		accessor: #priority
]
