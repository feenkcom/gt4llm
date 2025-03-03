Extension { #name : #GtLlmProvider }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmProvider >> gtFormatFor: aView [
	<gtView>
	format ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Format';
		priority: 2;
		text: [ NeoJSONWriter toStringPretty: self format ];
		styler: JSONParser gtStyler;
		actionButtonIcon: BrGlamorousVectorIcons playinspect
			tooltip: 'Inspect Format'
			action: [ :aButton | aButton phlow spawnObject: self format ]
]
