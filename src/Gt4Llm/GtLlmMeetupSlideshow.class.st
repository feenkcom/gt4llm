Class {
	#name : #GtLlmMeetupSlideshow,
	#superclass : #PrioritySlideshow,
	#category : #'Gt4Llm-Presentations'
}

{ #category : #accessing }
GtLlmMeetupSlideshow >> anActualUseCase: aSlide [
	<gtSlide>
	^ aSlide lepiterPage
		setPriority;
		startPage: (LeDatabase gtBook pageNamed: 'Case studies of Moldable Development')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> gt4llm: aSlide [
	<gtSlide>
	^ aSlide title
		setPriority;
		titleBottomPadding: 30;
		titleWithFormat: (self asSubtitle: 'gt4llm')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> gt4openAiBooklet: aSlide [
	<gtSlide>
	^ aSlide lepiterPage
		setPriority;
		startPage: ((LeDatabase databaseNamed: 'feenkcom/gt4llm/lepiter')
				pageNamed: 'gt4openai')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> gtPage [
	<lePage>
	<gtExample>
	<noTest>
	^ (LePage named: 'What is GT?')
		addSnippet: (LeTextSnippet new
				string: 'Let’s start exploring! A part of GT is Lepiter, a notebook environment. We are in it now.');
		addSnippet: (LeTextSnippet new string: 'Here is a simple code snippet:');
		addSnippet: (LePharoSnippet new code: '5 / 3');
		addSnippet: (LeTextSnippet new string: 'And another:');
		addSnippet: (LePharoSnippet new code: 'Color blue');
		addSnippet: (LeTextSnippet new string: 'And a more complex one:');
		addSnippet: (LePharoSnippet new
				code: 'GtGraphCircleNeighbourhoodExamples new emptyNeighborhoodWithThreeCirclesAndSpace');
		addSnippet: (LeYoutubeReferenceSnippet new
				urlString: 'https://www.youtube.com/watch?v=lqogvp1dGpk');
		yourself
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> orouborosPage: aSlide [
	<gtSlide>
	<text: 'I don’t usually write notes for my presentations, but I did for this slide. Here, you see the code that defines the page we are currently looking at. Yes, it’s self-referential. And it’s fun.'>
	^ aSlide classCoder
		setPriority;
		class: self class;
		expandMethodAt: (self class selectors sorted
				detectIndex: [ :aMethodName | aMethodName = #orouborosPage: ])
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> slidePriorities [
	"Instead of manually setting priorities, just list the slides in order here."

	<gtExample>
	^ #(#title:
		#whatIsGt:
		#whatIsGtPage:
		#orouborosPage:
		#whatIsItActually:
		#anActualUseCase:
		#gt4llm:
		#whatIsGtPageAgain:
		#gt4openAiBooklet:
		#thankYou:
		)
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> thankYou: aSlide [
	<gtSlide>
	^ aSlide titleWithFooter
		setPriority;
		titleBottomPadding: 30;
		subtitleBottomPadding: 40;
		titleWithFormat: (self asTitle: 'Thank you!');
		subtitleWithFormat: (self asTitle: 'Questions?');
		footerWithFormat: (self asBigText: 'https://github.com/feenkcom/gt4llm')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> title: aSlide [
	<gtSlide>
	^ aSlide titleWithFooter
		setPriority;
		titleBottomPadding: 30;
		subtitleBottomPadding: 40;
		titleWithFormat: (self asTitle: 'Software Development with LLMs');
		subtitleWithFormat: (self asTitle: 'in Glamorous Toolkit');
		footerWithFormat: (self asBigText: 'veit.heller@feenk.com')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> whatIsGt: aSlide [
	<gtSlide>
	^ aSlide title
		setPriority;
		titleBottomPadding: 30;
		titleWithFormat: (self asSubtitle: 'What is GT?')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> whatIsGtPage: aSlide [
	<gtSlide>
	^ aSlide lepiterPage
		setPriority;
		startPage: (self db pageNamed: 'What is GT?')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> whatIsGtPageAgain: aSlide [
	<gtSlide>
	^ aSlide lepiterPage
		setPriority;
		startPage: (self db pageNamed: 'What is GT?')
]

{ #category : #accessing }
GtLlmMeetupSlideshow >> whatIsItActually: aSlide [
	<gtSlide>
	^ aSlide title
		setPriority;
		titleBottomPadding: 30;
		titleWithFormat: (self asSubtitle: 'Okay, but... What is GT? What is it good for?')
]
