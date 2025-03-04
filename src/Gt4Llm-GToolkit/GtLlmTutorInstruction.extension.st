Extension { #name : #GtLlmTutorInstruction }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmTutorInstruction >> gtFormatsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Formats';
		priority: 2;
		items: [ formats sorted: [ :a :b | a priority < b priority ] ];
		column: 'Name' text: #name;
		column: 'Format' text: #format;
		column: 'Priority'
			text: #priority
			width: 70;
		column: 'Actions'
			stencil: [ :anItem | 
				BrButton new
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons cancel;
					label: 'Remove';
					action: [ :aButton | 
						formats remove: anItem.
						anItem removeFromSystem.
						aButton phlow fireToolUpdateWish ] ]
			width: 70
]
