Extension { #name : #GtLlmTutorAction }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorAction >> descriptionDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Description';
		beRequired;
		priority: 3;
		accessor: #description
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorAction >> examplesDescription [
	<magritteDescription>
	^ MAToManyRelationDescription new
		label: 'Examples';
		priority: 5;
		accessor: #examples;
		classes: {GtLlmTutorActionExample};
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
		  newItemStencil: [ GtLlmTutorActionExample new ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorAction >> formatDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Format';
		beRequired;
		priority: 5;
		accessor: #format
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorAction >> gtDefinitionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Definition';
		priority: 1;
		actionButtonIcon: BrGlamorousVectorIcons browse
			tooltip: 'Browse method'
			action: [ self definingMethod gtBrowse ];
		stencil: [ | coder |
			coder := GtPharoMethodCoder forMethod: self definingMethod.
			coder addOns addStyler: (GtLlmTutorFormatStyler new tutor: self tutor).
			coder asExpandedOnlyElement vFitContentLimited ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorAction >> initializeMethod [
	^ (thisContext stack at: 4) blocDefiningMethod
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorAction >> nameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Name';
		beRequired;
		priority: 1;
		accessor: #name
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorAction >> priorityDescription [
	<magritteDescription>
	^ MANumberDescription new
		label: 'Priority';
		priority: 2;
		accessor: #priority
]
