Extension { #name : #GtLlmAssistantFormat }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmAssistantFormat >> gtFormatsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Components';
		priority: 2;
		items: [ components sorted: [ :a :b | a priority < b priority ] ];
		column: 'Name' text: #name;
		column: 'Format' text: #format;
		column: 'Priority' text: #priority width: 70;
		column: 'Actions'
			stencil: [ :anItem | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons cancel;
					label: 'Remove';
					action: [ :aButton | 
						components remove: anItem.
						aButton phlow fireUpdateWish ] ]
		width: 70
]
