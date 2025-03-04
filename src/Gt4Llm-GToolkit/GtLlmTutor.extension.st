Extension { #name : #GtLlmTutor }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutor >> gtActionsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.

	^ aView forward
		title: 'Actions';
		priority: 10;
		object: [ self instruction ];
		view: #gtActionsFor:;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				| methodCoder |
				methodCoder := GtPharoNewMethodCoderElement new
						behavior: self class;
						methodCoderViewModelValueHolder: valueHolder;
						onMethodCoderSaved: [ self recomputeActions.
							anElement phlow fireToolUpdateWish.
							anElement fireEvent: BrDropdownHideWish new ];
						ensureMethodCoderViewModel.
				methodCoder pharoMethodCoderViewModel coderModel
					currentSourceString: 'gtACTIONNAME
 	<gtLlmTutorAction>
 	^ GtLlmTutorAction new
 		name: '''';
 		priority: 1;
 		description: '''';
 		examples: {}'.
				methodCoder ]
]

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutor >> gtFormatComponentsFor: aView [
	<gtView>
	| valueHolder |
	valueHolder := ValueHolder new.
	^ aView forward
		title: 'Formats';
		priority: 11;
		object: [ instruction ];
		view: #gtFormatsFor:;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add action'
			content: [ :anElement | 
				| methodCoder |
				methodCoder := GtPharoNewMethodCoderElement new
						behavior: self class;
						onMethodCoderSaved: [ :anAnnouncement | 
							| method |
							method := anAnnouncement method.
							self recomputeFormats.
							methodCoder phlow fireToolUpdateWish.
							methodCoder
								enqueueTask: (BlTaskAction new action: [ methodCoder fireEvent: BrDropdownHideWish new ]) ];
						ensureMethodCoderViewModel.
				methodCoder pharoMethodCoderViewModel coderModel
					currentSourceString: 'gtFORMATNAMEDescription
	<gtLlmTutorFormat>
	^ GtLlmTutorFormatDescription new
		name: '''';
		priority: 1;
		format: '''';
		example: '''''.
				methodCoder methodCoderViewModelValueHolder: valueHolder ]
]
