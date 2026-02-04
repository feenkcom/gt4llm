Extension { #name : #LePage }

{ #category : #'*Gt4LlmCore' }
LePage >> gtProposeATitleFor: anAction [
	<gtAction>
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Propose a title';
		priority: 10;
		target: LePageActionTarget;
		icon: BrGlamorousVectorIcons chat;
		menuItemGroup: BrMenuItemGroupConfiguration llm;
		action: [ :aButton | 
			| chat |
			chat := GtLChat new
					addResponseFormat: (GtLResponseStringFormat new name: 'String');
					sendWith: [ :m | 
						m
							pageObject: self;
							markdown: 'Propose a title for this page' ].
			aButton phlow spawnObject: chat ]
]

{ #category : #'*Gt4LlmCore' }
LePage >> gtReviewContentActionFor: anAction [
	"Adapted from: GtLChatOpenAILiveExamples>>#messageExample_lepiterPage_improveSingleTextSnippet"

	<gtAction>
	GtLConnectionRegistry instance hasConnectableDefaultConnection
		ifFalse: [ ^ anAction empty ].
	^ anAction button
		tooltip: 'Review the spelling, grammar and content of this page';
		target: LePageActionTarget;
		icon: BrGlamorousVectorIcons chat;
		menuItemGroup: BrMenuItemGroupConfiguration llm;
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
