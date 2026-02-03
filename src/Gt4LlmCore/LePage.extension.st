Extension { #name : #LePage }

{ #category : #'*Gt4LlmCore' }
LePage >> gtReviewContentActionFor: anAction [
	"Adapted from: GtLChatOpenAILiveExamples>>#messageExample_lepiterPage_improveSingleTextSnippet"

	<gtAction>
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Review the spelling, grammar and content of this page';
		target: LePageActionTarget;
		icon: BrGlamorousVectorIcons repair;
		menuItemGroup: BrMenuItemGroupConfiguration editing;
		action: [ :aButton | 
			| chat |
			chat := GtLChat new
					tools: GtLTools leSearch;
					sendWith: [ :message | 
						message
							markdown: 'Review the spelling, grammar, content and presentation of this page. Use LepiterTransformations to express proposed changes.';
							addInputModel: (GtLLepiterPageInputModel new
									name: self title;
									model: self);
							addResponseFormat: (GtLResponseMagritteFormat new
									name: 'LepiterTransformations';
									modelClass: GtLLepiterTransformations) ].
			aButton phlow spawnObject: chat ]
]
