# Home Page

## Overview

## Layout

### Sections 

The page consists of a few different sections

#### Briefing's header

Display the date, today's weather, summary of reminders that are overdue or due today

#### Overdue and due today

Showing the reminders that are overdue and then a list of reminders that are due today

#### 3rd party info section

Collection of widgets showing info pulled in from 3rd party sources, e.g. Stock market info, Sports results, Games today etc.

#### New task button

Quick way to add a new task

#### Upcoming reminders

Showing a list of high priority upcoming reminders 

#### Navigation

Buttons to navigate to other pages, reminders list, profile, etc

### 1. Phone Portrait Layout (Single Column with Vertical Scroll)

Concept: Prioritize essential information, maintain readability, and enable easy one-handed interaction.

**Layout Idea:**

* Top: A concise "Short Briefing Header" including the date and a greeting. This should be immediately visible without scrolling.
* Below Header: The "New Task" button. Given its importance, it should be easily accessible.
* Main Content (Vertically Stacked and Scrollable):
    * Overdue Section: Clearly highlighted at the top of the main content, demanding immediate attention.
    * Due Today Section: Following overdue tasks, presented clearly with times and relevant details.
    * "Widgets" Section (e.g., Sports, Stock Market): These can follow the core task lists. They might be simplified or provide a quick glance, with options to expand if needed.
* Bottom: The "Upcoming Preview Bar" spanning the full width. While it provides an overview, it might be collapsed or horizontally scrollable if space is extremely tight, to avoid overwhelming the vertical scroll.
* Navigation: A persistent bottom navigation bar for primary app sections.

**Key Considerations:**

* Readability: Ample vertical spacing between sections to prevent visual clutter.
* Tap Targets: Large enough tap targets for easy interaction.
* Accessibility: Ensuring good contrast and semantic labeling.
* Content Prioritization: Most important items (briefing, overdue) are at the top.

### 2. Tablet Portrait Layout (Two Columns with Primary Content on Left)

Concept: Utilize the increased horizontal space to display more information concurrently, balancing primary tasks with supplementary content.

**Layout Idea:**

* Top (Full Width): A "Short Briefing Header" (similar to phone, but possibly slightly more detailed) across the entire width, above the columns. This provides immediate context.
* Below Header (Two Columns):
    * Left Column (Primary - Wider): This should contain the core task-related information.
        * Overdue Section
        * Due Today Section
        * This column should be independently scrollable if its content exceeds the screen height.
    * Right Column (Secondary - Narrower): This column is for supplementary "widgets" or higher-priority items.
        * "High Priority" card (as seen in mockups)
        * "Sports" widget
        * "Stock Market" widget
        * This column should also be independently scrollable.
* Bottom (Full Width): The "Upcoming Preview Bar" spanning the entire width, similar to the phone layout but perhaps displaying more items horizontally without a scroll.

**Key Considerations:**

* Visual Hierarchy: The wider left column clearly signifies primary focus.
* Content Grouping: Related tasks are grouped. Supplementary info is nearby but distinct.
* Independent Scrolling: Allows users to interact with content in one column without affecting the other.

### 3. Tablet Landscape Layout (Three Columns with Clear Content Segmentation)

Concept: Maximize the large screen real estate to provide a comprehensive overview, allowing users to absorb a lot of information at a glance across distinct content areas.

**Layout Idea:**

* Top (Full Width, or implicitly handled by column headers): The overall "Today's Briefing" title, date, and possibly a more detailed greeting.
* Below Top (Three Columns):
    * Left Column (Overview/Actions - Moderate Width):
        * A more detailed "Today Briefing Column" (title, date, greeting, task summary).
        * The "New Task" button should be prominently placed here.
        * This column provides context and main actions.
    * Middle Column (Core Tasks - Wider):
        * Overdue Section
        * Due Today Section
        * This is the central focus for immediate tasks.
    * Right Column (Supplementary Widgets - Moderate Width):
        * "High Priority" card
        * "Sports" widget
        * "Stock Market" widget
        * This column offers secondary information or less urgent insights.
        * Each column should be independently scrollable if its content exceeds the screen height.
* Bottom (Full Width): The "Upcoming Preview Bar" spanning all three columns, providing a wide horizontal view of upcoming days.

**Key Considerations:**

* Information Density: High information density without feeling cluttered.
* Clear Segmentation: Each column has a distinct purpose.
* Efficiency: Users can quickly scan and identify relevant information in different areas.
