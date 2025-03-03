Extension { #name : #GtOpenAIFineTuningJob }

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIFineTuningJob >> gtUpdateActionFor: anAction [
	<gtAction>
	self client ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		tooltip: 'Update job';
		icon: BrGlamorousVectorIcons refresh;
		action: [ :aButton | aButton phlow spawnObject: (self refresh) ]
]

{ #category : #'*Gt4OpenAI-GToolkit' }
GtOpenAIFineTuningJob >> gtViewLossFor: aView [
	<gtView>
	^ aView explicit
		title: 'Training loss';
		priority: 4;
		stencil: [ | aData aChart |
			aData := GtPlotterDataGroup new
					values: ((self events reversed select: [ :anEvent | anEvent data isEmptyOrNil not ])
							collectWithIndex: [ :anEvent :anIndex | anIndex -> (anEvent data at: 'train_loss') ]);
					background: BrGlamorousColors primaryBorderColor.
			aChart := GtPlotterLineChart new.
			aChart with: aData.
			aChart valueX: #key.
			aChart scaleX: GtPlotterLinearScale new.
			aChart labelFormatX: [ :x | x asString ].
			aChart valueY: #value.
			aChart scaleY: GtPlotterLinearScale new.
			aChart labelFormatY: [ :x | x printShowingDecimalPlaces: 1 ].
			aChart ticksY: 4.
			aChart asElement height: 300 ];
		actionUpdateButton
]
