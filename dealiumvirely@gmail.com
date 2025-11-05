<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Dealsby Reservations Super Admin Dashboard</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

:root {
/* Charcoal gray and deep blue theme - matching Dealsby */
--bg-gradient-start: #1a2332;
--bg-gradient-end: #0f1922;
--bg-primary: linear-gradient(180deg, var(--bg-gradient-start) 0%, var(--bg-gradient-end) 100%);
--bg-secondary: rgba(26, 35, 50, 0.8);
--bg-tertiary: rgba(30, 45, 65, 0.7);
--bg-hover: rgba(40, 60, 85, 0.6);
--bg-card: rgba(35, 50, 70, 0.5);
--text-primary: #e4e9f0;
--text-secondary: #a8b5c7;
--text-tertiary: #7a8a9e;
--border-color: rgba(70, 100, 140, 0.2);
--primary: #4a9eff;
--success: #10b981;
--warning: #f59e0b;
--danger: #ef4444;
--info: #6366f1;
--purple: #a855f7;
--cyan: #06b6d4;
--pink: #ec4899;
--spacing-sm: 0.5rem;
--spacing-md: 1rem;
--spacing-lg: 1.5rem;
--radius-md: 12px;
--transition-base: 200ms;
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
-webkit-font-smoothing: antialiased;
-moz-osx-font-smoothing: grayscale;
}

* {
box-sizing: border-box;
margin: 0;
padding: 0;
}

body {
background: var(--bg-primary);
color: var(--text-primary);
font-size: 14px;
min-height: 100vh;
background-attachment: fixed;
overflow-x: hidden;
}

/* Header */
.admin-header {
background: rgba(15, 25, 38, 0.95);
border-bottom: 1px solid var(--border-color);
padding: 20px 40px;
backdrop-filter: blur(10px);
position: sticky;
top: 0;
z-index: 100;
}

.header-content {
display: flex;
justify-content: space-between;
align-items: center;
max-width: 1800px;
margin: 0 auto;
}

.header-title {
display: flex;
align-items: center;
gap: 15px;
}

.logo {
font-size: 32px;
}

.title-group h1 {
font-size: 24px;
font-weight: 700;
color: var(--text-primary);
margin-bottom: 4px;
}

.title-group p {
font-size: 13px;
color: var(--text-secondary);
}

.header-actions {
display: flex;
gap: 15px;
align-items: center;
}

.time-display {
background: var(--bg-card);
padding: 10px 16px;
border-radius: 8px;
font-size: 13px;
color: var(--text-secondary);
border: 1px solid var(--border-color);
}

.admin-user {
display: flex;
align-items: center;
gap: 12px;
padding: 10px 16px;
background: var(--bg-card);
border-radius: 8px;
border: 1px solid var(--border-color);
}

.admin-avatar {
width: 36px;
height: 36px;
border-radius: 50%;
background: linear-gradient(135deg, var(--primary), var(--purple));
display: flex;
align-items: center;
justify-content: center;
font-weight: 700;
font-size: 14px;
}

/* Main Container */
.dashboard-container {
max-width: 1800px;
margin: 0 auto;
padding: 30px 40px;
}

/* Stats Grid */
.stats-grid {
display: grid;
grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
gap: 20px;
margin-bottom: 30px;
}

.stat-card {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
transition: all var(--transition-base);
position: relative;
overflow: hidden;
cursor: pointer;
}

.stat-card::before {
content: '';
position: absolute;
top: 0;
left: 0;
right: 0;
height: 3px;
background: linear-gradient(90deg, var(--primary), var(--purple));
opacity: 0;
transition: opacity var(--transition-base);
}

.stat-card:hover {
transform: translateY(-4px);
box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
border-color: var(--primary);
}

.stat-card:hover::before {
opacity: 1;
}

.stat-card::after {
content: '🔍';
position: absolute;
top: 20px;
right: 20px;
font-size: 18px;
opacity: 0;
transition: opacity var(--transition-base);
}

.stat-card:hover::after {
opacity: 0.5;
}

.stat-header {
display: flex;
justify-content: space-between;
align-items: flex-start;
margin-bottom: 16px;
}

.stat-icon {
font-size: 28px;
padding: 12px;
background: rgba(74, 158, 255, 0.1);
border-radius: 10px;
display: flex;
align-items: center;
justify-content: center;
}

.stat-trend {
display: flex;
align-items: center;
gap: 6px;
font-size: 13px;
font-weight: 600;
padding: 4px 10px;
border-radius: 6px;
}

.trend-up {
color: var(--success);
background: rgba(16, 185, 129, 0.15);
}

.trend-down {
color: var(--danger);
background: rgba(239, 68, 68, 0.15);
}

.stat-value {
font-size: 36px;
font-weight: 800;
color: var(--text-primary);
margin-bottom: 8px;
line-height: 1;
}

.stat-label {
font-size: 13px;
color: var(--text-secondary);
font-weight: 500;
text-transform: uppercase;
letter-spacing: 0.5px;
}

.stat-sublabel {
font-size: 12px;
color: var(--text-tertiary);
margin-top: 8px;
}

/* Modal Styles */
.modal-overlay {
position: fixed;
top: 0;
left: 0;
right: 0;
bottom: 0;
background: rgba(0, 0, 0, 0.85);
backdrop-filter: blur(8px);
display: flex;
align-items: center;
justify-content: center;
z-index: 10000;
padding: 20px;
animation: fadeIn 0.3s ease-out;
}

.modal-content {
background: linear-gradient(180deg, rgba(26, 35, 50, 0.95), rgba(15, 25, 38, 0.95));
border: 1px solid var(--border-color);
border-radius: 16px;
max-width: 1200px;
width: 100%;
max-height: 90vh;
overflow-y: auto;
padding: 32px;
position: relative;
animation: scaleIn 0.3s ease-out;
box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
}

.modal-header {
display: flex;
justify-content: space-between;
align-items: flex-start;
margin-bottom: 24px;
padding-bottom: 20px;
border-bottom: 1px solid var(--border-color);
}

.modal-title {
font-size: 28px;
font-weight: 800;
color: var(--text-primary);
display: flex;
align-items: center;
gap: 12px;
}

.modal-close {
width: 40px;
height: 40px;
border-radius: 8px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
color: var(--text-secondary);
font-size: 24px;
cursor: pointer;
display: flex;
align-items: center;
justify-content: center;
transition: all var(--transition-base);
}

.modal-close:hover {
background: var(--danger);
border-color: var(--danger);
color: white;
transform: rotate(90deg);
}

.modal-stats-grid {
display: grid;
grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
gap: 16px;
margin-bottom: 24px;
}

.modal-stat-card {
background: rgba(255, 255, 255, 0.03);
border: 1px solid var(--border-color);
border-radius: 10px;
padding: 20px;
text-align: center;
}

.modal-stat-value {
font-size: 32px;
font-weight: 800;
color: var(--primary);
margin-bottom: 8px;
}

.modal-stat-label {
font-size: 12px;
color: var(--text-secondary);
text-transform: uppercase;
letter-spacing: 0.5px;
}

.modal-stat-change {
font-size: 11px;
margin-top: 6px;
font-weight: 600;
}

.modal-chart-container {
background: rgba(0, 0, 0, 0.2);
border-radius: 12px;
padding: 24px;
margin-bottom: 24px;
}

.modal-section {
margin-bottom: 32px;
}

.modal-section-title {
font-size: 18px;
font-weight: 700;
color: var(--text-primary);
margin-bottom: 16px;
display: flex;
align-items: center;
gap: 10px;
}

/* Chart Section */
.chart-section {
display: grid;
grid-template-columns: 2fr 1fr;
gap: 20px;
margin-bottom: 30px;
}

.chart-card {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
cursor: pointer;
transition: all var(--transition-base);
}

.chart-card:hover {
transform: translateY(-2px);
box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
border-color: var(--primary);
}

.chart-header {
display: flex;
justify-content: space-between;
align-items: center;
margin-bottom: 20px;
}

.chart-title {
font-size: 18px;
font-weight: 700;
color: var(--text-primary);
}

.chart-controls {
display: flex;
gap: 8px;
}

.chart-btn {
padding: 8px 14px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 6px;
color: var(--text-secondary);
font-size: 12px;
font-weight: 600;
cursor: pointer;
transition: all var(--transition-base);
}

.chart-btn.active {
background: var(--primary);
color: white;
border-color: var(--primary);
}

.chart-btn:hover {
background: var(--bg-hover);
border-color: var(--primary);
}

.chart-placeholder {
height: 300px;
background: rgba(0, 0, 0, 0.2);
border-radius: 8px;
display: flex;
align-items: center;
justify-content: center;
position: relative;
overflow: hidden;
}

/* Business Grid */
.content-grid {
display: grid;
grid-template-columns: 1fr 1fr;
gap: 20px;
margin-bottom: 30px;
}

.content-card {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
}

.content-header {
display: flex;
justify-content: space-between;
align-items: center;
margin-bottom: 20px;
}

.content-title {
font-size: 16px;
font-weight: 700;
color: var(--text-primary);
display: flex;
align-items: center;
gap: 10px;
}

.badge {
padding: 4px 10px;
border-radius: 6px;
font-size: 11px;
font-weight: 700;
}

.badge-primary {
background: rgba(74, 158, 255, 0.2);
color: var(--primary);
}

.badge-success {
background: rgba(16, 185, 129, 0.2);
color: var(--success);
}

.badge-warning {
background: rgba(245, 158, 11, 0.2);
color: var(--warning);
}

.badge-danger {
background: rgba(239, 68, 68, 0.2);
color: var(--danger);
}

.badge-info {
background: rgba(99, 102, 241, 0.2);
color: var(--info);
}

/* Business List */
.business-list {
display: flex;
flex-direction: column;
gap: 12px;
max-height: 400px;
overflow-y: auto;
padding-right: 8px;
}

.business-item {
background: rgba(255, 255, 255, 0.02);
border: 1px solid var(--border-color);
border-radius: 8px;
padding: 16px;
display: flex;
justify-content: space-between;
align-items: center;
transition: all var(--transition-base);
cursor: pointer;
}

.business-item:hover {
background: var(--bg-hover);
border-color: var(--primary);
transform: translateX(4px);
}

.business-info {
display: flex;
align-items: center;
gap: 12px;
flex: 1;
}

.business-avatar {
width: 48px;
height: 48px;
border-radius: 10px;
background: linear-gradient(135deg, var(--primary), var(--purple));
display: flex;
align-items: center;
justify-content: center;
font-size: 20px;
font-weight: 700;
}

.business-details h4 {
font-size: 14px;
font-weight: 600;
color: var(--text-primary);
margin-bottom: 4px;
}

.business-details p {
font-size: 12px;
color: var(--text-secondary);
}

.business-stats {
display: flex;
gap: 16px;
text-align: right;
}

.business-stat-item {
display: flex;
flex-direction: column;
}

.business-stat-value {
font-size: 16px;
font-weight: 700;
color: var(--primary);
}

.business-stat-label {
font-size: 10px;
color: var(--text-tertiary);
text-transform: uppercase;
}

/* Template Usage */
.template-grid {
display: grid;
gap: 12px;
}

.template-item {
background: rgba(255, 255, 255, 0.02);
border: 1px solid var(--border-color);
border-radius: 8px;
padding: 16px;
transition: all var(--transition-base);
cursor: pointer;
}

.template-item:hover {
background: var(--bg-hover);
border-color: var(--primary);
transform: translateX(4px);
}

.template-header {
display: flex;
justify-content: space-between;
align-items: center;
margin-bottom: 12px;
}

.template-name {
font-size: 14px;
font-weight: 600;
color: var(--text-primary);
display: flex;
align-items: center;
gap: 8px;
}

.template-count {
font-size: 16px;
font-weight: 700;
color: var(--primary);
}

.usage-bar {
height: 8px;
background: rgba(255, 255, 255, 0.05);
border-radius: 4px;
overflow: hidden;
margin-bottom: 8px;
}

.usage-fill {
height: 100%;
background: linear-gradient(90deg, var(--primary), var(--purple));
border-radius: 4px;
transition: width 0.5s ease;
}

.usage-stats {
display: flex;
justify-content: space-between;
font-size: 11px;
color: var(--text-tertiary);
}

/* Activity Log */
.activity-log {
max-height: 400px;
overflow-y: auto;
display: flex;
flex-direction: column;
gap: 12px;
padding-right: 8px;
}

.activity-item {
background: rgba(255, 255, 255, 0.02);
border-left: 3px solid var(--primary);
border-radius: 6px;
padding: 14px;
display: flex;
gap: 12px;
transition: all var(--transition-base);
}

.activity-item:hover {
background: var(--bg-hover);
transform: translateX(4px);
}

.activity-icon {
font-size: 20px;
width: 36px;
height: 36px;
display: flex;
align-items: center;
justify-content: center;
background: rgba(74, 158, 255, 0.15);
border-radius: 8px;
flex-shrink: 0;
}

.activity-content {
flex: 1;
}

.activity-text {
font-size: 13px;
color: var(--text-primary);
margin-bottom: 4px;
}

.activity-meta {
font-size: 11px;
color: var(--text-tertiary);
display: flex;
gap: 12px;
}

/* Full Width Section */
.full-width-section {
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: var(--radius-md);
padding: 24px;
backdrop-filter: blur(10px);
margin-bottom: 30px;
}

/* Data Table */
.data-table {
width: 100%;
border-collapse: collapse;
}

.data-table thead {
background: rgba(0, 0, 0, 0.2);
}

.data-table th {
padding: 14px 16px;
text-align: left;
font-size: 12px;
font-weight: 700;
color: var(--text-secondary);
text-transform: uppercase;
letter-spacing: 0.5px;
border-bottom: 1px solid var(--border-color);
}

.data-table td {
padding: 14px 16px;
font-size: 13px;
color: var(--text-primary);
border-bottom: 1px solid rgba(70, 100, 140, 0.1);
}

.data-table tbody tr {
transition: all var(--transition-base);
}

.data-table tbody tr:hover {
background: var(--bg-hover);
}

.status-badge {
padding: 6px 12px;
border-radius: 6px;
font-size: 11px;
font-weight: 700;
text-transform: uppercase;
display: inline-block;
}

.status-active {
background: rgba(16, 185, 129, 0.2);
color: var(--success);
}

.status-inactive {
background: rgba(100, 116, 139, 0.2);
color: var(--text-tertiary);
}

.status-trial {
background: rgba(245, 158, 11, 0.2);
color: var(--warning);
}

/* Scrollbar Styling */
::-webkit-scrollbar {
width: 8px;
height: 8px;
}

::-webkit-scrollbar-track {
background: rgba(0, 0, 0, 0.2);
border-radius: 4px;
}

::-webkit-scrollbar-thumb {
background: var(--border-color);
border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
background: var(--primary);
}

/* Animations */
@keyframes fadeIn {
from {
opacity: 0;
}
to {
opacity: 1;
}
}

@keyframes scaleIn {
from {
opacity: 0;
transform: scale(0.9);
}
to {
opacity: 1;
transform: scale(1);
}
}

@keyframes slideIn {
from {
opacity: 0;
transform: translateY(20px);
}
to {
opacity: 1;
transform: translateY(0);
}
}

@keyframes pulse {
0%, 100% {
opacity: 1;
}
50% {
opacity: 0.7;
}
}

.fade-in {
animation: slideIn 0.5s ease-out forwards;
}

/* Chart Canvas */
.chart-canvas {
width: 100%;
height: 300px;
}

/* Responsive */
@media (max-width: 1400px) {
.chart-section {
grid-template-columns: 1fr;
}
}

@media (max-width: 1024px) {
.content-grid {
grid-template-columns: 1fr;
}
.stats-grid {
grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
}
}

@media (max-width: 768px) {
.dashboard-container {
padding: 20px;
}
.admin-header {
padding: 16px 20px;
}
.header-content {
flex-direction: column;
gap: 16px;
}
.stats-grid {
grid-template-columns: 1fr;
}
.modal-content {
padding: 20px;
}
}

/* Quick Action Buttons */
.quick-actions {
display: flex;
gap: 12px;
margin-bottom: 30px;
flex-wrap: wrap;
}

.action-btn {
padding: 12px 20px;
background: var(--bg-card);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
font-weight: 600;
cursor: pointer;
transition: all var(--transition-base);
display: flex;
align-items: center;
gap: 8px;
}

.action-btn:hover {
background: var(--primary);
border-color: var(--primary);
transform: translateY(-2px);
box-shadow: 0 4px 12px rgba(74, 158, 255, 0.3);
}

/* Revenue Chart */
.revenue-breakdown {
display: grid;
grid-template-columns: repeat(4, 1fr);
gap: 16px;
margin-top: 20px;
}

.revenue-item {
background: rgba(255, 255, 255, 0.03);
padding: 16px;
border-radius: 8px;
border: 1px solid var(--border-color);
text-align: center;
}

.revenue-amount {
font-size: 24px;
font-weight: 700;
color: var(--primary);
margin-bottom: 8px;
}

.revenue-label {
font-size: 12px;
color: var(--text-secondary);
text-transform: uppercase;
letter-spacing: 0.5px;
}

/* Comparison Grid */
.comparison-grid {
display: grid;
grid-template-columns: repeat(2, 1fr);
gap: 16px;
margin-top: 20px;
}

.comparison-item {
background: rgba(255, 255, 255, 0.02);
padding: 16px;
border-radius: 8px;
border: 1px solid var(--border-color);
}

.comparison-label {
font-size: 12px;
color: var(--text-secondary);
margin-bottom: 8px;
text-transform: uppercase;
}

.comparison-value {
font-size: 20px;
font-weight: 700;
color: var(--text-primary);
}

/* Detail List */
.detail-list {
display: flex;
flex-direction: column;
gap: 12px;
}

.detail-item {
background: rgba(255, 255, 255, 0.02);
padding: 16px;
border-radius: 8px;
border: 1px solid var(--border-color);
display: flex;
justify-content: space-between;
align-items: center;
}

.detail-item-label {
font-size: 14px;
color: var(--text-secondary);
}

.detail-item-value {
font-size: 16px;
font-weight: 700;
color: var(--primary);
}

/* Progress Ring */
.progress-ring-container {
display: flex;
align-items: center;
justify-content: center;
margin: 20px 0;
}

</style>
</head>
<body>

<!-- Header -->
<header class="admin-header">
<div class="header-content">
<div class="header-title">
<div class="logo">🍽️</div>
<div class="title-group">
<h1>Dealsby Reservations Super Admin Dashboard</h1>
<p>Comprehensive Business Intelligence & Analytics Platform</p>
</div>
</div>
<div class="header-actions">
<div class="time-display" id="currentTime">Loading...</div>
<div class="admin-user">
<div class="admin-avatar">VM</div>
<div>
<div style="font-size: 13px; font-weight: 600; color: var(--text-primary);">Virely Management</div>
<div style="font-size: 11px; color: var(--text-tertiary);">Super Admin</div>
</div>
</div>
</div>
</div>
</header>

<!-- Main Dashboard -->
<div class="dashboard-container">

<!-- Quick Actions -->
<div class="quick-actions">
<button class="action-btn" onclick="refreshDashboard()">
<span>🔄</span> Refresh Data
</button>
<button class="action-btn" onclick="exportReport()">
<span>📊</span> Export Report
</button>
<button class="action-btn" onclick="viewDetailedAnalytics()">
<span>📈</span> Detailed Analytics
</button>
<button class="action-btn" onclick="manageSubscriptions()">
<span>💳</span> Manage Subscriptions
</button>
<button class="action-btn" onclick="viewGeographicDistribution()">
<span>🌍</span> Geographic View
</button>
</div>

<!-- Key Metrics - CLICKABLE FOR DRILL-DOWN -->
<div class="stats-grid">
<div class="stat-card fade-in" style="animation-delay: 0s" onclick="showBusinessesModal()">
<div class="stat-header">
<div class="stat-icon">🏢</div>
<div class="stat-trend trend-up">
↗ 12.5%
</div>
</div>
<div class="stat-value" id="totalBusinesses">247</div>
<div class="stat-label">Total Businesses Subscribed</div>
<div class="stat-sublabel">+28 new businesses this month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.1s" onclick="showRevenueModal()">
<div class="stat-header">
<div class="stat-icon">💰</div>
<div class="stat-trend trend-up">
↗ 18.3%
</div>
</div>
<div class="stat-value">$124.5K</div>
<div class="stat-label">Monthly Recurring Revenue</div>
<div class="stat-sublabel">+$18.2K from last month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.2s" onclick="showReservationsModal()">
<div class="stat-header">
<div class="stat-icon">📅</div>
<div class="stat-trend trend-up">
↗ 24.7%
</div>
</div>
<div class="stat-value" id="totalReservations">18,432</div>
<div class="stat-label">Total Reservations (This Month)</div>
<div class="stat-sublabel">3,642 today across all businesses</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.3s" onclick="showUptimeModal()">
<div class="stat-header">
<div class="stat-icon">⚡</div>
<div class="stat-trend trend-up">
↗ 8.9%
</div>
</div>
<div class="stat-value">99.8%</div>
<div class="stat-label">Platform Uptime</div>
<div class="stat-sublabel">99.8% availability last 30 days</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.4s" onclick="showUsersModal()">
<div class="stat-header">
<div class="stat-icon">👥</div>
<div class="stat-trend trend-up">
↗ 15.2%
</div>
</div>
<div class="stat-value">43,892</div>
<div class="stat-label">Active End Users</div>
<div class="stat-sublabel">Customers making reservations</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.5s" onclick="showRatingModal()">
<div class="stat-header">
<div class="stat-icon">⭐</div>
<div class="stat-trend trend-up">
↗ 3.2%
</div>
</div>
<div class="stat-value">4.7</div>
<div class="stat-label">Average Rating</div>
<div class="stat-sublabel">From 8,234 customer reviews</div>
</div>

<!-- NEW KPIs -->
<div class="stat-card fade-in" style="animation-delay: 0.6s" onclick="showChurnModal()">
<div class="stat-header">
<div class="stat-icon">📉</div>
<div class="stat-trend trend-down">
↓ 2.1%
</div>
</div>
<div class="stat-value">3.2%</div>
<div class="stat-label">Monthly Churn Rate</div>
<div class="stat-sublabel">8 businesses cancelled this month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.7s" onclick="showNoShowModal()">
<div class="stat-header">
<div class="stat-icon">❌</div>
<div class="stat-trend trend-down">
↓ 5.3%
</div>
</div>
<div class="stat-value">8.4%</div>
<div class="stat-label">No-Show Rate</div>
<div class="stat-sublabel">1,548 no-shows this month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.8s" onclick="showCAC Modal()">
<div class="stat-header">
<div class="stat-icon">💵</div>
<div class="stat-trend trend-down">
↓ 8.7%
</div>
</div>
<div class="stat-value">$342</div>
<div class="stat-label">Customer Acquisition Cost</div>
<div class="stat-sublabel">Down from $375 last month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 0.9s" onclick="showRetentionModal()">
<div class="stat-header">
<div class="stat-icon">🔁</div>
<div class="stat-trend trend-up">
↗ 6.8%
</div>
</div>
<div class="stat-value">87.3%</div>
<div class="stat-label">Customer Retention Rate</div>
<div class="stat-sublabel">12-month retention metric</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 1s" onclick="showARPUModal()">
<div class="stat-header">
<div class="stat-icon">💳</div>
<div class="stat-trend trend-up">
↗ 11.2%
</div>
</div>
<div class="stat-value">$504</div>
<div class="stat-label">Average Revenue Per User</div>
<div class="stat-sublabel">Per business per month</div>
</div>

<div class="stat-card fade-in" style="animation-delay: 1.1s" onclick="showTableTurnoverModal()">
<div class="stat-header">
<div class="stat-icon">🔄</div>
<div class="stat-trend trend-up">
↗ 4.5%
</div>
</div>
<div class="stat-value">3.2x</div>
<div class="stat-label">Average Table Turnover</div>
<div class="stat-sublabel">Per day across all businesses</div>
</div>
</div>

<!-- Additional Business Statistics Panels -->
<div class="content-grid">
<!-- Peak Hours Analysis -->
<div class="content-card fade-in" style="animation-delay: 1.2s">
<div class="content-header">
<div class="content-title">
⏰ Peak Hours Analysis
<span class="badge badge-info">Live Data</span>
</div>
</div>
<div class="template-grid">
<div class="template-item">
<div class="template-header">
<div class="template-name">🌅 Lunch Rush (11AM-2PM)</div>
<div class="template-count" style="color: var(--warning);">6,234</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 75%; background: var(--warning);"></div>
</div>
<div class="usage-stats">
<span>75% capacity</span>
<span>34% of daily traffic</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌆 Dinner Peak (6PM-9PM)</div>
<div class="template-count" style="color: var(--danger);">8,847</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 95%; background: var(--danger);"></div>
</div>
<div class="usage-stats">
<span>95% capacity</span>
<span>48% of daily traffic</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌙 Late Night (9PM-Close)</div>
<div class="template-count" style="color: var(--success);">2,189</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 35%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>35% capacity</span>
<span>12% of daily traffic</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">☀️ Off-Peak Hours</div>
<div class="template-count" style="color: var(--cyan);">1,114</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 20%; background: var(--cyan);"></div>
</div>
<div class="usage-stats">
<span>20% capacity</span>
<span>6% of daily traffic</span>
</div>
</div>
</div>
</div>

<!-- Revenue by Plan -->
<div class="content-card fade-in" style="animation-delay: 1.3s">
<div class="content-header">
<div class="content-title">
💎 Revenue by Subscription Plan
<span class="badge badge-success">$124.5K MRR</span>
</div>
</div>
<div class="template-grid">
<div class="template-item" style="cursor: pointer;" onclick="showPlanDetails('enterprise')">
<div class="template-header">
<div class="template-name">🏆 Enterprise Plan</div>
<div class="template-count" style="color: var(--purple);">$68.4K</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 55%; background: var(--purple);"></div>
</div>
<div class="usage-stats">
<span>55% of MRR</span>
<span>42 businesses @ $1,629/mo</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showPlanDetails('professional')">
<div class="template-header">
<div class="template-name">💼 Professional Plan</div>
<div class="template-count" style="color: var(--primary);">$38.9K</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 31%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>31% of MRR</span>
<span>89 businesses @ $437/mo</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showPlanDetails('starter')">
<div class="template-header">
<div class="template-name">🚀 Starter Plan</div>
<div class="template-count" style="color: var(--success);">$17.2K</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 14%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>14% of MRR</span>
<span>116 businesses @ $148/mo</span>
</div>
</div>
</div>
</div>
</div>

<!-- Charts Section - CLICKABLE -->
<div class="chart-section">
<div class="chart-card fade-in" style="animation-delay: 1.4s" onclick="showRevenueChartModal()">
<div class="chart-header">
<div class="chart-title">📈 Revenue & Growth Analytics</div>
<div class="chart-controls">
<button class="chart-btn active" onclick="event.stopPropagation(); setChartPeriod('7d')">7D</button>
<button class="chart-btn" onclick="event.stopPropagation(); setChartPeriod('30d')">30D</button>
<button class="chart-btn" onclick="event.stopPropagation(); setChartPeriod('90d')">90D</button>
<button class="chart-btn" onclick="event.stopPropagation(); setChartPeriod('1y')">1Y</button>
</div>
</div>
<canvas id="revenueChart" class="chart-canvas"></canvas>
<div class="revenue-breakdown">
<div class="revenue-item">
<div class="revenue-amount">$124.5K</div>
<div class="revenue-label">This Month</div>
</div>
<div class="revenue-item">
<div class="revenue-amount">$106.3K</div>
<div class="revenue-label">Last Month</div>
</div>
<div class="revenue-item">
<div class="revenue-amount">$1.2M</div>
<div class="revenue-label">YTD Revenue</div>
</div>
<div class="revenue-item">
<div class="revenue-amount">$1.5M</div>
<div class="revenue-label">Projected Annual</div>
</div>
</div>
</div>

<div class="chart-card fade-in" style="animation-delay: 1.5s" onclick="showSubscriptionChartModal()">
<div class="chart-header">
<div class="chart-title">🎯 Business Distribution</div>
</div>
<canvas id="subscriptionChart" class="chart-canvas"></canvas>
</div>
</div>

<!-- Content Grid -->
<div class="content-grid">
<!-- Top Performing Businesses - CLICKABLE -->
<div class="content-card fade-in" style="animation-delay: 1.6s">
<div class="content-header">
<div class="content-title">
🏆 Top Performing Businesses
<span class="badge badge-primary">Live</span>
</div>
</div>
<div class="business-list" id="topBusinesses">
<!-- Populated by JavaScript -->
</div>
</div>

<!-- Template Usage - CLICKABLE -->
<div class="content-card fade-in" style="animation-delay: 1.7s">
<div class="content-header">
<div class="content-title">
📋 Template Utilization
<span class="badge badge-success">8 Templates</span>
</div>
</div>
<div class="template-grid" id="templateUsage">
<!-- Populated by JavaScript -->
</div>
</div>
</div>

<!-- Geographic Distribution -->
<div class="content-grid">
<div class="content-card fade-in" style="animation-delay: 1.8s">
<div class="content-header">
<div class="content-title">
🌍 Geographic Distribution
<span class="badge badge-info">247 Locations</span>
</div>
</div>
<div class="template-grid">
<div class="template-item">
<div class="template-header">
<div class="template-name">🗽 Northeast Region</div>
<div class="template-count" style="color: var(--primary);">87</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 35%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>35% of businesses</span>
<span>$42.8K MRR</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌴 Southeast Region</div>
<div class="template-count" style="color: var(--success);">64</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 26%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>26% of businesses</span>
<span>$31.2K MRR</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🌊 West Coast</div>
<div class="template-count" style="color: var(--purple);">58</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 23%; background: var(--purple);"></div>
</div>
<div class="usage-stats">
<span>23% of businesses</span>
<span>$29.6K MRR</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">🏔️ Midwest Region</div>
<div class="template-count" style="color: var(--warning);">38</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 16%; background: var(--warning);"></div>
</div>
<div class="usage-stats">
<span>16% of businesses</span>
<span>$20.9K MRR</span>
</div>
</div>
</div>
</div>

<!-- Customer Satisfaction Metrics -->
<div class="content-card fade-in" style="animation-delay: 1.9s">
<div class="content-header">
<div class="content-title">
😊 Customer Satisfaction Metrics
<span class="badge badge-success">4.7★ Average</span>
</div>
</div>
<div class="template-grid">
<div class="template-item">
<div class="template-header">
<div class="template-name">⭐⭐⭐⭐⭐ 5 Stars</div>
<div class="template-count" style="color: var(--success);">5,892</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 72%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>72% of reviews</span>
<span>Excellent service</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">⭐⭐⭐⭐ 4 Stars</div>
<div class="template-count" style="color: var(--primary);">1,647</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 20%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>20% of reviews</span>
<span>Good experience</span>
</div>
</div>

<div class="template-item">
<div class="template-header">
<div class="template-name">⭐⭐⭐ 3 Stars & Below</div>
<div class="template-count" style="color: var(--danger);">695</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 8%; background: var(--danger);"></div>
</div>
<div class="usage-stats">
<span>8% of reviews</span>
<span>Needs improvement</span>
</div>
</div>
</div>
</div>
</div>

<!-- Recent Activity -->
<div class="content-grid">
<div class="content-card fade-in" style="animation-delay: 2s">
<div class="content-header">
<div class="content-title">
⚡ Real-Time Activity Feed
<span class="badge badge-warning" id="activityCount">42 events</span>
</div>
</div>
<div class="activity-log" id="activityFeed">
<!-- Populated by JavaScript -->
</div>
</div>

<!-- System Health -->
<div class="content-card fade-in" style="animation-delay: 2.1s">
<div class="content-header">
<div class="content-title">
💊 System Health & Performance
<span class="badge badge-success">Healthy</span>
</div>
</div>
<div class="template-grid">
<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">🌐 API Response Time</div>
<div class="template-count" style="color: var(--success);">124ms</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 15%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>Excellent</span>
<span>Target: &lt;200ms</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">💾 Database Load</div>
<div class="template-count" style="color: var(--warning);">68%</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 68%; background: var(--warning);"></div>
</div>
<div class="usage-stats">
<span>Moderate</span>
<span>Capacity: 32% free</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">🚀 Server Uptime</div>
<div class="template-count" style="color: var(--success);">99.8%</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 99.8%; background: var(--success);"></div>
</div>
<div class="usage-stats">
<span>Excellent (28d 4h 32m)</span>
<span>Last incident: 14 days ago</span>
</div>
</div>

<div class="template-item" style="cursor: pointer;" onclick="showSystemHealthModal()">
<div class="template-header">
<div class="template-name">📊 Active Sessions</div>
<div class="template-count" style="color: var(--primary);">2,847</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: 45%; background: var(--primary);"></div>
</div>
<div class="usage-stats">
<span>Normal load</span>
<span>Peak capacity: 6,000</span>
</div>
</div>
</div>
</div>
</div>

<!-- Detailed Subscription Table -->
<div class="full-width-section fade-in" style="animation-delay: 2.2s">
<div class="content-header" style="margin-bottom: 20px;">
<div class="content-title" style="font-size: 18px;">
📊 All Business Subscriptions
</div>
<div style="display: flex; gap: 12px;">
<input type="text" id="searchBusinesses" placeholder="Search businesses..." style="
padding: 10px 16px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
width: 300px;
" />
<select id="filterStatus" style="
padding: 10px 16px;
background: rgba(255, 255, 255, 0.05);
border: 1px solid var(--border-color);
border-radius: 8px;
color: var(--text-primary);
font-size: 13px;
cursor: pointer;
">
<option value="all">All Status</option>
<option value="active">Active</option>
<option value="trial">Trial</option>
<option value="inactive">Inactive</option>
</select>
</div>
</div>
<div style="overflow-x: auto;">
<table class="data-table">
<thead>
<tr>
<th>Business Name</th>
<th>Owner</th>
<th>Plan</th>
<th>Status</th>
<th>Template</th>
<th>Reservations (30d)</th>
<th>Revenue</th>
<th>Join Date</th>
<th>Actions</th>
</tr>
</thead>
<tbody id="businessTable">
<!-- Populated by JavaScript -->
</tbody>
</table>
</div>
</div>

</div>

<!-- Modal Container -->
<div id="modalContainer"></div>

<script>
// ==================== STATE MANAGEMENT ====================
const dashboardState = {
businesses: [],
templates: [],
activities: [],
metrics: {},
chartPeriod: '7d'
};

// ==================== INITIALIZE DASHBOARD ====================
function initializeDashboard() {
updateTime();
setInterval(updateTime, 1000);
generateMockData();
renderTopBusinesses();
renderTemplateUsage();
renderActivityFeed();
renderBusinessTable();
initializeCharts();
startRealtimeUpdates();
}

// ==================== TIME DISPLAY ====================
function updateTime() {
const now = new Date();
const options = {
weekday: 'long',
year: 'numeric',
month: 'long',
day: 'numeric',
hour: '2-digit',
minute: '2-digit',
second: '2-digit'
};
document.getElementById('currentTime').textContent = now.toLocaleDateString('en-US', options);
}

// ==================== MOCK DATA GENERATION ====================
function generateMockData() {
// Generate business data
const businessNames = [
'The Golden Spoon Restaurant',
'Bella Vista Trattoria',
'Sakura Japanese Cuisine',
'Le Petit Bistro',
'Ocean Breeze Seafood',
'Mountain View Lodge',
'Urban Grille & Bar',
'Sunset Terrace Dining',
'The Cozy Corner Cafe',
'Majestic Palace Restaurant',
'Riverside Grill House',
'The Artisan Kitchen',
'Harmony Fusion Restaurant',
'The Velvet Room',
'Coastal Catch Seafood',
'Pine Ridge Steakhouse',
'The Garden Bistro',
'Silver Oak Restaurant',
'Metropolitan Dining',
'The Heritage Table'
];

const owners = [
'John Smith', 'Maria Garcia', 'David Chen', 'Sarah Johnson',
'Michael Brown', 'Emily Davis', 'James Wilson', 'Lisa Anderson',
'Robert Taylor', 'Jennifer Martinez', 'William Thomas', 'Jessica Lee',
'Christopher White', 'Amanda Harris', 'Daniel Martin', 'Michelle Thompson',
'Matthew Garcia', 'Ashley Rodriguez', 'Joseph Lewis', 'Stephanie Walker'
];

const plans = ['Starter', 'Professional', 'Enterprise', 'Premium'];
const statuses = ['active', 'trial', 'active', 'active', 'inactive'];
const templates = [
'Restaurant Classic',
'Modern Minimalist',
'Fine Dining Elegant',
'Casual Eatery',
'Bar & Lounge',
'Quick Service',
'Family Style',
'Upscale Contemporary'
];

dashboardState.businesses = businessNames.map((name, index) => ({
id: index + 1,
name,
owner: owners[index % owners.length],
plan: plans[Math.floor(Math.random() * plans.length)],
status: statuses[Math.floor(Math.random() * statuses.length)],
template: templates[Math.floor(Math.random() * templates.length)],
reservations: Math.floor(Math.random() * 500) + 50,
revenue: (Math.random() * 5000 + 500).toFixed(2),
joinDate: new Date(2024, Math.floor(Math.random() * 10), Math.floor(Math.random() * 28) + 1).toLocaleDateString(),
rating: (Math.random() * 1.5 + 3.5).toFixed(1),
activeUsers: Math.floor(Math.random() * 1000) + 100,
noShowRate: (Math.random() * 15 + 2).toFixed(1),
avgTableTurnover: (Math.random() * 2 + 2).toFixed(1)
}));

// Sort by reservations for top performers
dashboardState.businesses.sort((a, b) => b.reservations - a.reservations);

// Generate template usage data
const templateCounts = {};
dashboardState.businesses.forEach(business => {
templateCounts[business.template] = (templateCounts[business.template] || 0) + 1;
});

dashboardState.templates = Object.entries(templateCounts).map(([name, count]) => ({
name,
count,
percentage: (count / dashboardState.businesses.length * 100).toFixed(1)
}));

// Generate activity data
generateActivityFeed();
}

// ==================== ACTIVITY FEED ====================
function generateActivityFeed() {
const activityTypes = [
{ icon: '🏢', text: 'registered a new business', color: '--success' },
{ icon: '📅', text: 'created a reservation', color: '--primary' },
{ icon: '✅', text: 'checked in a customer', color: '--info' },
{ icon: '💳', text: 'upgraded subscription plan', color: '--purple' },
{ icon: '⚙️', text: 'updated business settings', color: '--warning' },
{ icon: '📊', text: 'generated monthly report', color: '--cyan' },
{ icon: '🎨', text: 'changed template design', color: '--pink' },
{ icon: '❌', text: 'cancelled a reservation', color: '--danger' }
];

dashboardState.activities = [];
for (let i = 0; i < 20; i++) {
const business = dashboardState.businesses[Math.floor(Math.random() * Math.min(10, dashboardState.businesses.length))];
const activity = activityTypes[Math.floor(Math.random() * activityTypes.length)];
const minutesAgo = Math.floor(Math.random() * 120);

dashboardState.activities.push({
icon: activity.icon,
text: `${business.name} ${activity.text}`,
time: minutesAgo < 60 ? `${minutesAgo} minutes ago` : `${Math.floor(minutesAgo / 60)} hours ago`,
location: business.owner,
color: activity.color
});
}
}

// ==================== RENDER FUNCTIONS ====================
function renderTopBusinesses() {
const container = document.getElementById('topBusinesses');
const topBusinesses = dashboardState.businesses.slice(0, 8);

container.innerHTML = topBusinesses.map(business => `
<div class="business-item" onclick="showBusinessDetailsModal(${business.id})">
<div class="business-info">
<div class="business-avatar">${business.name.charAt(0)}</div>
<div class="business-details">
<h4>${business.name}</h4>
<p>Owner: ${business.owner} • ${business.plan} Plan</p>
</div>
</div>
<div class="business-stats">
<div class="business-stat-item">
<div class="business-stat-value">${business.reservations}</div>
<div class="business-stat-label">Reservations</div>
</div>
<div class="business-stat-item">
<div class="business-stat-value">$${business.revenue}</div>
<div class="business-stat-label">Revenue</div>
</div>
<div class="business-stat-item">
<div class="business-stat-value">${business.rating}★</div>
<div class="business-stat-label">Rating</div>
</div>
</div>
</div>
`).join('');
}

function renderTemplateUsage() {
const container = document.getElementById('templateUsage');
const sortedTemplates = [...dashboardState.templates].sort((a, b) => b.count - a.count);

container.innerHTML = sortedTemplates.map(template => `
<div class="template-item" onclick="showTemplateDetailsModal('${template.name}')">
<div class="template-header">
<div class="template-name">
<span style="font-size: 18px;">📋</span>
${template.name}
</div>
<div class="template-count">${template.count}</div>
</div>
<div class="usage-bar">
<div class="usage-fill" style="width: ${template.percentage}%"></div>
</div>
<div class="usage-stats">
<span>${template.percentage}% of businesses</span>
<span>${template.count} active</span>
</div>
</div>
`).join('');
}

function renderActivityFeed() {
const container = document.getElementById('activityFeed');

container.innerHTML = dashboardState.activities.map(activity => `
<div class="activity-item">
<div class="activity-icon">${activity.icon}</div>
<div class="activity-content">
<div class="activity-text">${activity.text}</div>
<div class="activity-meta">
<span>⏱️ ${activity.time}</span>
<span>👤 ${activity.location}</span>
</div>
</div>
</div>
`).join('');

document.getElementById('activityCount').textContent = `${dashboardState.activities.length} events`;
}

function renderBusinessTable() {
const tbody = document.getElementById('businessTable');

tbody.innerHTML = dashboardState.businesses.map(business => `
<tr onclick="showBusinessDetailsModal(${business.id})" style="cursor: pointer;">
<td>
<div style="display: flex; align-items: center; gap: 10px;">
<div style="width: 36px; height: 36px; border-radius: 8px; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700;">
${business.name.charAt(0)}
</div>
<strong>${business.name}</strong>
</div>
</td>
<td>${business.owner}</td>
<td><span class="badge badge-primary">${business.plan}</span></td>
<td><span class="status-badge status-${business.status}">${business.status}</span></td>
<td>${business.template}</td>
<td><strong>${business.reservations}</strong></td>
<td><strong style="color: var(--success);">$${business.revenue}</strong></td>
<td>${business.joinDate}</td>
<td>
<button style="padding: 6px 12px; background: var(--primary); border: none; border-radius: 6px; color: white; cursor: pointer; font-size: 11px; font-weight: 600;" onclick="event.stopPropagation(); showBusinessDetailsModal(${business.id})">
View Details
</button>
</td>
</tr>
`).join('');
}

// ==================== CHARTS ====================
function initializeCharts() {
createRevenueChart();
createSubscriptionChart();
}

function createRevenueChart() {
const canvas = document.getElementById('revenueChart');
const ctx = canvas.getContext('2d');

canvas.width = canvas.offsetWidth;
canvas.height = 300;

const data = [85, 92, 78, 105, 98, 112, 124.5];
const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
gradient.addColorStop(0, 'rgba(74, 158, 255, 0.3)');
gradient.addColorStop(1, 'rgba(74, 158, 255, 0)');

const padding = 40;
const chartWidth = canvas.width - padding * 2;
const chartHeight = canvas.height - padding * 2;
const maxValue = Math.max(...data) * 1.2;
const stepX = chartWidth / (data.length - 1);

const points = data.map((value, index) => ({
x: padding + index * stepX,
y: canvas.height - padding - (value / maxValue * chartHeight)
}));

ctx.strokeStyle = 'rgba(255, 255, 255, 0.05)';
ctx.lineWidth = 1;
for (let i = 0; i <= 4; i++) {
const y = padding + (chartHeight / 4) * i;
ctx.beginPath();
ctx.moveTo(padding, y);
ctx.lineTo(canvas.width - padding, y);
ctx.stroke();
}

ctx.fillStyle = gradient;
ctx.beginPath();
ctx.moveTo(points[0].x, canvas.height - padding);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.lineTo(points[points.length - 1].x, canvas.height - padding);
ctx.closePath();
ctx.fill();

ctx.strokeStyle = '#4a9eff';
ctx.lineWidth = 3;
ctx.beginPath();
ctx.moveTo(points[0].x, points[0].y);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.stroke();

points.forEach((point, index) => {
ctx.fillStyle = '#4a9eff';
ctx.beginPath();
ctx.arc(point.x, point.y, 5, 0, Math.PI * 2);
ctx.fill();
ctx.strokeStyle = '#1a2332';
ctx.lineWidth = 2;
ctx.stroke();

ctx.fillStyle = '#a8b5c7';
ctx.font = '11px Inter';
ctx.textAlign = 'center';
ctx.fillText(labels[index], point.x, canvas.height - 15);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 11px Inter';
ctx.fillText(`$${data[index]}K`, point.x, point.y - 15);
});
}

function createSubscriptionChart() {
const canvas = document.getElementById('subscriptionChart');
const ctx = canvas.getContext('2d');

canvas.width = canvas.offsetWidth;
canvas.height = 300;

const data = [
{ label: 'Active', value: 198, color: '#10b981' },
{ label: 'Trial', value: 32, color: '#f59e0b' },
{ label: 'Inactive', value: 17, color: '#64748b' }
];

const total = data.reduce((sum, item) => sum + item.value, 0);
const centerX = canvas.width / 2;
const centerY = canvas.height / 2 - 20;
const radius = 90;

let currentAngle = -Math.PI / 2;

data.forEach((item, index) => {
const sliceAngle = (item.value / total) * Math.PI * 2;

ctx.fillStyle = item.color;
ctx.beginPath();
ctx.moveTo(centerX, centerY);
ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + sliceAngle);
ctx.closePath();
ctx.fill();

const labelAngle = currentAngle + sliceAngle / 2;
const labelX = centerX + Math.cos(labelAngle) * (radius + 30);
const labelY = centerY + Math.sin(labelAngle) * (radius + 30);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 13px Inter';
ctx.textAlign = 'center';
ctx.fillText(item.label, labelX, labelY);

const percentage = ((item.value / total) * 100).toFixed(1);
ctx.font = '11px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText(`${item.value} (${percentage}%)`, labelX, labelY + 16);

currentAngle += sliceAngle;
});

ctx.fillStyle = '#1a2332';
ctx.beginPath();
ctx.arc(centerX, centerY, radius * 0.6, 0, Math.PI * 2);
ctx.fill();

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 24px Inter';
ctx.textAlign = 'center';
ctx.fillText(total, centerX, centerY - 5);
ctx.font = '12px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText('Total', centerX, centerY + 15);
}

// ==================== MODAL FUNCTIONS ====================
function createModal(title, icon, content) {
const modalContainer = document.getElementById('modalContainer');
modalContainer.innerHTML = `
<div class="modal-overlay" onclick="closeModal(event)">
<div class="modal-content" onclick="event.stopPropagation()">
<div class="modal-header">
<div class="modal-title">
${icon} ${title}
</div>
<div class="modal-close" onclick="closeModal()">×</div>
</div>
${content}
</div>
</div>
`;
}

function closeModal(event) {
if (event && event.target.className !== 'modal-overlay' && event.target.className !== 'modal-close') return;
const modalContainer = document.getElementById('modalContainer');
const overlay = modalContainer.querySelector('.modal-overlay');
if (overlay) {
overlay.style.opacity = '0';
setTimeout(() => {
modalContainer.innerHTML = '';
}, 300);
}
}

// ==================== DETAILED MODAL VIEWS ====================
function showBusinessesModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">247</div>
<div class="modal-stat-label">Total Businesses</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +28 this month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">198</div>
<div class="modal-stat-label">Active Subscriptions</div>
<div class="modal-stat-change" style="color: var(--success);">↗ 80.2% of total</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">32</div>
<div class="modal-stat-label">Trial Period</div>
<div class="modal-stat-change" style="color: var(--warning);">⚡ 13.0% of total</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">17</div>
<div class="modal-stat-label">Inactive</div>
<div class="modal-stat-change" style="color: var(--danger);">⚠️ 6.9% of total</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📈 Growth Trend (Last 12 Months)</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">New Signups</div>
<div class="comparison-value" style="color: var(--success);">+156</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Churned</div>
<div class="comparison-value" style="color: var(--danger);">-34</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Net Growth</div>
<div class="comparison-value" style="color: var(--primary);">+122</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Growth Rate</div>
<div class="comparison-value" style="color: var(--success);">+97.6%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🏆 Business Type Distribution</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Fine Dining Restaurants</div>
<div class="detail-item-value">89 (36%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Casual Dining</div>
<div class="detail-item-value">72 (29%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Quick Service</div>
<div class="detail-item-value">48 (19%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Bars & Lounges</div>
<div class="detail-item-value">38 (15%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Key Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Fine dining segment shows highest engagement with 94% active rate</p>
<p style="margin-bottom: 8px;">• 28 new businesses added this month - highest growth in Q4</p>
<p style="margin-bottom: 8px;">• Northeast region leads with 87 businesses (35% market share)</p>
<p>• Trial-to-paid conversion rate at strong 78.5%</p>
</div>
</div>
`;
createModal('Total Businesses Subscribed', '🏢', content);
}

function showRevenueModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">$124.5K</div>
<div class="modal-stat-label">This Month MRR</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +$18.2K (17.1%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$106.3K</div>
<div class="modal-stat-label">Last Month MRR</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Previous period</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$1.2M</div>
<div class="modal-stat-label">Year-to-Date</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +42.3% YoY</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$1.5M</div>
<div class="modal-stat-label">Annual Run Rate</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 Projected</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💎 Revenue Breakdown by Plan</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Enterprise ($1,629/mo) - 42 businesses</div>
<div class="detail-item-value" style="color: var(--purple);">$68,418 (55%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Professional ($437/mo) - 89 businesses</div>
<div class="detail-item-value" style="color: var(--primary);">$38,893 (31%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter ($148/mo) - 116 businesses</div>
<div class="detail-item-value" style="color: var(--success);">$17,168 (14%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📈 Revenue Metrics</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">ARPU (Avg Revenue/User)</div>
<div class="comparison-value" style="color: var(--primary);">$504/mo</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Customer Lifetime Value</div>
<div class="comparison-value" style="color: var(--success);">$15,120</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Monthly Growth Rate</div>
<div class="comparison-value" style="color: var(--success);">+17.1%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Revenue Churn</div>
<div class="comparison-value" style="color: var(--warning);">2.8%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Revenue Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Enterprise tier driving majority of growth with 12 new upgrades this month</p>
<p style="margin-bottom: 8px;">• Average contract value increased 11.2% due to feature adoption</p>
<p style="margin-bottom: 8px;">• Upsell rate at 23% - businesses upgrading within 3 months</p>
<p>• On track to reach $1.5M ARR by year end if current growth continues</p>
</div>
</div>
`;
createModal('Monthly Recurring Revenue Analysis', '💰', content);
}

function showReservationsModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">18,432</div>
<div class="modal-stat-label">This Month Total</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +3,652 (24.7%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">3,642</div>
<div class="modal-stat-label">Today's Reservations</div>
<div class="modal-stat-change" style="color: var(--primary);">⚡ Live count</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">74.6</div>
<div class="modal-stat-label">Avg Per Business</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +11.2 per day</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">91.6%</div>
<div class="modal-stat-label">Show-Up Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +5.3% improvement</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">⏰ Reservations by Time of Day</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">🌆 Dinner Peak (6PM-9PM)</div>
<div class="detail-item-value" style="color: var(--danger);">8,847 (48%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌅 Lunch Rush (11AM-2PM)</div>
<div class="detail-item-value" style="color: var(--warning);">6,234 (34%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌙 Late Night (9PM-Close)</div>
<div class="detail-item-value" style="color: var(--success);">2,189 (12%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">☀️ Off-Peak Hours</div>
<div class="detail-item-value" style="color: var(--cyan);">1,162 (6%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Party Size Distribution</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">2-Person Tables</div>
<div class="comparison-value" style="color: var(--primary);">7,836 (42.5%)</div>
</div>
<div class="comparison-item">
<div class="comparison-label">4-Person Tables</div>
<div class="comparison-value" style="color: var(--success);">6,289 (34.1%)</div>
</div>
<div class="comparison-item">
<div class="comparison-label">6+ Large Parties</div>
<div class="comparison-value" style="color: var(--purple);">2,947 (16.0%)</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Single Diners</div>
<div class="comparison-value" style="color: var(--cyan);">1,360 (7.4%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Reservation Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Saturday dinner slot most popular with 95% capacity fill rate</p>
<p style="margin-bottom: 8px;">• Average booking lead time: 4.2 days (up from 3.8 days)</p>
<p style="margin-bottom: 8px;">• Mobile bookings represent 67% of all reservations</p>
<p>• Repeat customer rate at impressive 42.3%</p>
</div>
</div>
`;
createModal('Reservation Analytics', '📅', content);
}

function showNoShowModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">8.4%</div>
<div class="modal-stat-label">Overall No-Show Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↓ -5.3% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">1,548</div>
<div class="modal-stat-label">No-Shows This Month</div>
<div class="modal-stat-change" style="color: var(--danger);">⚠️ Lost revenue</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$78.4K</div>
<div class="modal-stat-label">Estimated Lost Revenue</div>
<div class="modal-stat-change" style="color: var(--danger);">💸 Opportunity cost</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">73%</div>
<div class="modal-stat-label">SMS Confirmation Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Reduces no-shows 42%</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 No-Show Rate by Time Slot</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">🌙 Late Night (9PM-Close)</div>
<div class="detail-item-value" style="color: var(--danger);">14.2%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌆 Dinner Peak (6PM-9PM)</div>
<div class="detail-item-value" style="color: var(--warning);">8.7%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌅 Lunch Rush (11AM-2PM)</div>
<div class="detail-item-value" style="color: var(--success);">5.3%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">☀️ Off-Peak Hours</div>
<div class="detail-item-value" style="color: var(--success);">3.8%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🎯 Recommendations to Reduce No-Shows</div>
<div style="background: rgba(245, 158, 11, 0.1); border-left: 3px solid var(--warning); padding: 16px; border-radius: 8px; margin-bottom: 12px;">
<strong style="display: block; margin-bottom: 8px;">Immediate Actions:</strong>
<p style="margin-bottom: 6px;">• Enable SMS/Email confirmations 24hrs before reservation</p>
<p style="margin-bottom: 6px;">• Implement credit card requirement for large parties (6+)</p>
<p>• Offer waitlist auto-fill for last-minute cancellations</p>
</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<strong style="display: block; margin-bottom: 8px;">Long-term Strategies:</strong>
<p style="margin-bottom: 6px;">• Penalty system for repeat no-show customers</p>
<p style="margin-bottom: 6px;">• Deposit requirement during peak hours</p>
<p>• Loyalty program rewards for perfect attendance</p>
</div>
</div>
`;
createModal('No-Show Rate Analysis', '❌', content);
}

function showChurnModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">3.2%</div>
<div class="modal-stat-label">Monthly Churn Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↓ -2.1% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">8</div>
<div class="modal-stat-label">Businesses Lost</div>
<div class="modal-stat-change" style="color: var(--danger);">⚠️ This month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$4,032</div>
<div class="modal-stat-label">MRR Lost</div>
<div class="modal-stat-change" style="color: var(--danger);">💸 Monthly impact</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">87.3%</div>
<div class="modal-stat-label">Retention Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ 12-month metric</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📉 Churn Reasons</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Went out of business</div>
<div class="detail-item-value" style="color: var(--text-tertiary);">3 (37.5%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Pricing concerns</div>
<div class="detail-item-value" style="color: var(--warning);">2 (25%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Switched to competitor</div>
<div class="detail-item-value" style="color: var(--danger);">2 (25%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Feature gaps</div>
<div class="detail-item-value" style="color: var(--warning);">1 (12.5%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Churn Prevention Strategy</div>
<div style="background: rgba(239, 68, 68, 0.1); border-left: 3px solid var(--danger); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Implement early warning system for at-risk accounts (low usage, payment issues)</p>
<p style="margin-bottom: 8px;">• Dedicated success manager for Enterprise tier customers</p>
<p style="margin-bottom: 8px;">• Quarterly business reviews with top 50 revenue-generating accounts</p>
<p>• Win-back campaign for churned customers with 3-month discount offer</p>
</div>
</div>
`;
createModal('Churn Rate Analysis', '📉', content);
}

function showRetentionModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">87.3%</div>
<div class="modal-stat-label">12-Month Retention</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +6.8% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">92.1%</div>
<div class="modal-stat-label">6-Month Retention</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Strong early retention</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$15,120</div>
<div class="modal-stat-label">Customer LTV</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 30-month avg tenure</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">78.5%</div>
<div class="modal-stat-label">Trial Conversion</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Best in class</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Retention by Plan Type</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Enterprise Plan</div>
<div class="detail-item-value" style="color: var(--success);">94.2%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Professional Plan</div>
<div class="detail-item-value" style="color: var(--primary);">88.7%</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter Plan</div>
<div class="detail-item-value" style="color: var(--warning);">82.3%</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Retention Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Enterprise customers showing exceptional 94.2% retention - premium support paying off</p>
<p style="margin-bottom: 8px;">• First 90 days critical: 92% of customers who survive this period stay 12+ months</p>
<p style="margin-bottom: 8px;">• Power users (>50 reservations/month) have 97% retention rate</p>
<p>• Onboarding improvements increased 6-month retention by 6.8%</p>
</div>
</div>
`;
createModal('Customer Retention Analysis', '🔁', content);
}

function showARPUModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">$504</div>
<div class="modal-stat-label">ARPU This Month</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +$51 (+11.2%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$453</div>
<div class="modal-stat-label">ARPU Last Month</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Previous period</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$1,629</div>
<div class="modal-stat-label">Enterprise ARPU</div>
<div class="modal-stat-change" style="color: var(--purple);">💎 Premium tier</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">23%</div>
<div class="modal-stat-label">Upsell Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Within 3 months</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 ARPU by Plan</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Enterprise Plan</div>
<div class="detail-item-value" style="color: var(--purple);">$1,629/mo</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Professional Plan</div>
<div class="detail-item-value" style="color: var(--primary);">$437/mo</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Starter Plan</div>
<div class="detail-item-value" style="color: var(--success);">$148/mo</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 ARPU Growth Drivers</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 12 businesses upgraded from Professional to Enterprise this month</p>
<p style="margin-bottom: 8px;">• Add-on features (SMS reminders, advanced analytics) contributing $47/mo avg</p>
<p style="margin-bottom: 8px;">• Price increase implemented in January driving +8.7% ARPU lift</p>
<p>• Enterprise tier adoption growing 3x faster than other plans</p>
</div>
</div>
`;
createModal('Average Revenue Per User', '💳', content);
}

function showTableTurnoverModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">3.2x</div>
<div class="modal-stat-label">Avg Daily Turnover</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +4.5% improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">4.8x</div>
<div class="modal-stat-label">Peak Hour Turnover</div>
<div class="modal-stat-change" style="color: var(--primary);">⚡ Dinner service</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">76 min</div>
<div class="modal-stat-label">Avg Dining Duration</div>
<div class="modal-stat-change" style="color: var(--warning);">⏱️ Per seating</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$147</div>
<div class="modal-stat-label">Avg Check Size</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +$12 per table</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🔄 Turnover by Service Period</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">🌆 Dinner Service (5PM-10PM)</div>
<div class="detail-item-value" style="color: var(--success);">4.8x turns</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌅 Lunch Service (11AM-3PM)</div>
<div class="detail-item-value" style="color: var(--primary);">3.4x turns</div>
</div>
<div class="detail-item">
<div class="detail-item-label">🌙 Late Night (10PM-Close)</div>
<div class="detail-item-value" style="color: var(--warning);">1.9x turns</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Optimization Opportunities</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Fine dining restaurants averaging 2.1x (luxury experience = longer stays)</p>
<p style="margin-bottom: 8px;">• Quick service establishments achieving 5.2x turnover rate</p>
<p style="margin-bottom: 8px;">• Implementing table time limits during peak hours could increase revenue 12-15%</p>
<p>• Smart seating algorithms improving turnover by 8.3% on average</p>
</div>
</div>
`;
createModal('Table Turnover Analysis', '🔄', content);
}

function showCACModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">$342</div>
<div class="modal-stat-label">Current CAC</div>
<div class="modal-stat-change" style="color: var(--success);">↓ -$33 (-8.7%)</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$375</div>
<div class="modal-stat-label">Previous CAC</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Last month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$15,120</div>
<div class="modal-stat-label">Customer LTV</div>
<div class="modal-stat-change" style="color: var(--primary);">30-month tenure</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">44:1</div>
<div class="modal-stat-label">LTV:CAC Ratio</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Excellent ratio</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Acquisition Channels</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Organic Search & SEO</div>
<div class="detail-item-value" style="color: var(--success);">$178 CAC (42%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Referral Program</div>
<div class="detail-item-value" style="color: var(--success);">$89 CAC (28%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Paid Advertising</div>
<div class="detail-item-value" style="color: var(--warning);">$568 CAC (18%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Content Marketing</div>
<div class="detail-item-value" style="color: var(--primary);">$245 CAC (12%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 CAC Optimization Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Referral program driving lowest CAC at $89 - incentivize more referrals</p>
<p style="margin-bottom: 8px;">• Paid advertising CAC high at $568 - focus on organic channels</p>
<p style="margin-bottom: 8px;">• LTV:CAC ratio of 44:1 is exceptional (3:1 is considered healthy)</p>
<p>• Payback period: 2.3 months (industry standard: 12 months)</p>
</div>
</div>
`;
createModal('Customer Acquisition Cost', '💵', content);
}

function showBusinessDetailsModal(businessId) {
const business = dashboardState.businesses.find(b => b.id === businessId);
if (!business) return;

const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">${business.reservations}</div>
<div class="modal-stat-label">Monthly Reservations</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +12.3% vs last month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$${business.revenue}</div>
<div class="modal-stat-label">Monthly Revenue</div>
<div class="modal-stat-change" style="color: var(--success);">💰 Contribution</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${business.rating}★</div>
<div class="modal-stat-label">Customer Rating</div>
<div class="modal-stat-change" style="color: var(--primary);">⭐ ${Math.floor(Math.random() * 200 + 50)} reviews</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${business.activeUsers}</div>
<div class="modal-stat-label">Active Customers</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +8.2% growth</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📋 Business Information</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Owner</div>
<div class="detail-item-value">${business.owner}</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Subscription Plan</div>
<div class="detail-item-value">${business.plan}</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Template</div>
<div class="detail-item-value">${business.template}</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Status</div>
<div class="detail-item-value"><span class="status-badge status-${business.status}">${business.status}</span></div>
</div>
<div class="detail-item">
<div class="detail-item-label">Member Since</div>
<div class="detail-item-value">${business.joinDate}</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Performance Metrics</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">No-Show Rate</div>
<div class="comparison-value" style="color: ${parseFloat(business.noShowRate) > 10 ? 'var(--danger)' : 'var(--success)'};">${business.noShowRate}%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Table Turnover</div>
<div class="comparison-value" style="color: var(--primary);">${business.avgTableTurnover}x</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Repeat Customer Rate</div>
<div class="comparison-value" style="color: var(--success);">${Math.floor(Math.random() * 30 + 35)}%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Avg Check Size</div>
<div class="comparison-value" style="color: var(--primary);">$${Math.floor(Math.random() * 80 + 60)}</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Business Health</div>
<div style="background: ${business.status === 'active' ? 'rgba(16, 185, 129, 0.1)' : 'rgba(245, 158, 11, 0.1)'}; border-left: 3px solid ${business.status === 'active' ? 'var(--success)' : 'var(--warning)'}; padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• ${business.status === 'active' ? 'Business performing well with steady growth' : business.status === 'trial' ? 'In trial period - monitor for conversion' : 'Inactive account - reach out for reactivation'}</p>
<p style="margin-bottom: 8px;">• Feature adoption: ${Math.floor(Math.random() * 30 + 60)}% of available features in use</p>
<p>• Last login: ${Math.floor(Math.random() * 24 + 1)} hours ago</p>
</div>
</div>
`;
createModal(business.name, '🏢', content);
}

function showTemplateDetailsModal(templateName) {
const template = dashboardState.templates.find(t => t.name === templateName);
const businesses = dashboardState.businesses.filter(b => b.template === templateName);

const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">${template.count}</div>
<div class="modal-stat-label">Active Businesses</div>
<div class="modal-stat-change" style="color: var(--primary);">${template.percentage}% adoption</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${businesses.reduce((sum, b) => sum + b.reservations, 0).toLocaleString()}</div>
<div class="modal-stat-label">Total Reservations</div>
<div class="modal-stat-change" style="color: var(--success);">📅 This month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">$${(businesses.reduce((sum, b) => sum + parseFloat(b.revenue), 0) / 1000).toFixed(1)}K</div>
<div class="modal-stat-label">Total Revenue</div>
<div class="modal-stat-change" style="color: var(--success);">💰 Generated</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${(businesses.reduce((sum, b) => sum + parseFloat(b.rating), 0) / businesses.length).toFixed(1)}★</div>
<div class="modal-stat-label">Avg Rating</div>
<div class="modal-stat-change" style="color: var(--primary);">⭐ Customer satisfaction</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🏆 Top Performing Businesses Using This Template</div>
<div class="detail-list">
${businesses.slice(0, 5).map(b => `
<div class="detail-item">
<div class="detail-item-label">${b.name}</div>
<div class="detail-item-value">${b.reservations} reservations</div>
</div>
`).join('')}
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Template Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• ${template.count} businesses actively using this template</p>
<p style="margin-bottom: 8px;">• Average ${Math.floor(businesses.reduce((sum, b) => sum + b.reservations, 0) / businesses.length)} reservations per business</p>
<p>• Template accounts for ${template.percentage}% of all platform activity</p>
</div>
</div>
`;
createModal(templateName + ' Template', '📋', content);
}

function showSystemHealthModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">124ms</div>
<div class="modal-stat-label">API Response Time</div>
<div class="modal-stat-change" style="color: var(--success);">✓ Excellent</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">68%</div>
<div class="modal-stat-label">Database Load</div>
<div class="modal-stat-change" style="color: var(--warning);">⚠️ Moderate</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">99.8%</div>
<div class="modal-stat-label">Server Uptime</div>
<div class="modal-stat-change" style="color: var(--success);">✓ 28d 4h 32m</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">2,847</div>
<div class="modal-stat-label">Active Sessions</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 Real-time</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">🌐 Infrastructure Status</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Web Servers</div>
<div class="detail-item-value" style="color: var(--success);">✓ All operational (8/8)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Database Cluster</div>
<div class="detail-item-value" style="color: var(--success);">✓ Healthy (3 nodes)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">CDN Performance</div>
<div class="detail-item-value" style="color: var(--success);">✓ 42ms avg latency</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Storage Capacity</div>
<div class="detail-item-value" style="color: var(--warning);">⚠️ 72% used</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Backup Status</div>
<div class="detail-item-value" style="color: var(--success);">✓ Last backup: 2h ago</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Performance Trends (7 Days)</div>
<div class="comparison-grid">
<div class="comparison-item">
<div class="comparison-label">Avg Response Time</div>
<div class="comparison-value" style="color: var(--success);">134ms</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Peak Concurrent Users</div>
<div class="comparison-value" style="color: var(--primary);">4,892</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Error Rate</div>
<div class="comparison-value" style="color: var(--success);">0.08%</div>
</div>
<div class="comparison-item">
<div class="comparison-label">Data Transferred</div>
<div class="comparison-value" style="color: var(--primary);">2.4 TB</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">⚠️ Alerts & Recommendations</div>
<div style="background: rgba(245, 158, 11, 0.1); border-left: 3px solid var(--warning); padding: 16px; border-radius: 8px; margin-bottom: 12px;">
<p style="margin-bottom: 8px;"><strong>Medium Priority:</strong></p>
<p style="margin-bottom: 6px;">• Database load at 68% - consider scaling during peak hours</p>
<p>• Storage at 72% - plan capacity expansion within 30 days</p>
</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;"><strong>All Systems Nominal:</strong></p>
<p style="margin-bottom: 6px;">• API response times well below target threshold</p>
<p style="margin-bottom: 6px;">• Uptime exceeding 99.5% SLA commitment</p>
<p>• Error rates within acceptable ranges</p>
</div>
</div>
`;
createModal('System Health & Performance', '💊', content);
}

function showRevenueChartModal() {
const content = `
<div class="modal-section">
<div class="modal-section-title">📈 Detailed Revenue Analysis</div>
<div class="modal-chart-container">
<canvas id="detailedRevenueChart" style="width: 100%; height: 400px;"></canvas>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Monthly Comparison</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">November 2024</div>
<div class="detail-item-value" style="color: var(--primary);">$124,500</div>
</div>
<div class="detail-item">
<div class="detail-item-label">October 2024</div>
<div class="detail-item-value" style="color: var(--text-secondary);">$106,300</div>
</div>
<div class="detail-item">
<div class="detail-item-label">September 2024</div>
<div class="detail-item-value" style="color: var(--text-secondary);">$98,700</div>
</div>
<div class="detail-item">
<div class="detail-item-label">August 2024</div>
<div class="detail-item-value" style="color: var(--text-secondary);">$95,200</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Revenue Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Consistent month-over-month growth averaging 14.2%</p>
<p style="margin-bottom: 8px;">• Q4 on track for record $368K quarterly revenue</p>
<p style="margin-bottom: 8px;">• Enterprise tier upgrades driving 55% of revenue growth</p>
<p>• Projected to reach $1.5M ARR by end of fiscal year</p>
</div>
</div>
`;
createModal('Revenue & Growth Analytics', '💰', content);

setTimeout(() => {
const canvas = document.getElementById('detailedRevenueChart');
if (canvas) {
const ctx = canvas.getContext('2d');
canvas.width = canvas.offsetWidth;
canvas.height = 400;

const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov'];
const data = [68, 72, 78, 82, 87, 91, 95, 95.2, 98.7, 106.3, 124.5];

const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
gradient.addColorStop(0, 'rgba(74, 158, 255, 0.4)');
gradient.addColorStop(1, 'rgba(74, 158, 255, 0)');

const padding = 60;
const chartWidth = canvas.width - padding * 2;
const chartHeight = canvas.height - padding * 2;
const maxValue = Math.max(...data) * 1.2;
const stepX = chartWidth / (data.length - 1);

const points = data.map((value, index) => ({
x: padding + index * stepX,
y: canvas.height - padding - (value / maxValue * chartHeight)
}));

// Draw grid
ctx.strokeStyle = 'rgba(255, 255, 255, 0.05)';
ctx.lineWidth = 1;
for (let i = 0; i <= 5; i++) {
const y = padding + (chartHeight / 5) * i;
ctx.beginPath();
ctx.moveTo(padding, y);
ctx.lineTo(canvas.width - padding, y);
ctx.stroke();
}

// Draw area
ctx.fillStyle = gradient;
ctx.beginPath();
ctx.moveTo(points[0].x, canvas.height - padding);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.lineTo(points[points.length - 1].x, canvas.height - padding);
ctx.closePath();
ctx.fill();

// Draw line
ctx.strokeStyle = '#4a9eff';
ctx.lineWidth = 4;
ctx.beginPath();
ctx.moveTo(points[0].x, points[0].y);
points.forEach(point => ctx.lineTo(point.x, point.y));
ctx.stroke();

// Draw points and labels
points.forEach((point, index) => {
ctx.fillStyle = '#4a9eff';
ctx.beginPath();
ctx.arc(point.x, point.y, 6, 0, Math.PI * 2);
ctx.fill();
ctx.strokeStyle = '#1a2332';
ctx.lineWidth = 3;
ctx.stroke();

ctx.fillStyle = '#a8b5c7';
ctx.font = '12px Inter';
ctx.textAlign = 'center';
ctx.fillText(months[index], point.x, canvas.height - 25);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 13px Inter';
ctx.fillText(`$${data[index]}K`, point.x, point.y - 15);
});
}
}, 100);
}

function showSubscriptionChartModal() {
const content = `
<div class="modal-section">
<div class="modal-section-title">🎯 Subscription Distribution Details</div>
<div class="modal-chart-container">
<canvas id="detailedSubscriptionChart" style="width: 100%; height: 400px;"></canvas>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Subscription Breakdown</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Active Subscriptions</div>
<div class="detail-item-value" style="color: var(--success);">198 (80.2%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Trial Subscriptions</div>
<div class="detail-item-value" style="color: var(--warning);">32 (13.0%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Inactive Subscriptions</div>
<div class="detail-item-value" style="color: var(--text-tertiary);">17 (6.9%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Subscription Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 80.2% active rate indicates strong product-market fit</p>
<p style="margin-bottom: 8px;">• 32 businesses in trial - potential for $16K+ additional MRR</p>
<p style="margin-bottom: 8px;">• Inactive accounts represent reactivation opportunity</p>
<p>• Trial-to-paid conversion running at healthy 78.5%</p>
</div>
</div>
`;
createModal('Business Distribution Analysis', '🎯', content);

setTimeout(() => {
const canvas = document.getElementById('detailedSubscriptionChart');
if (canvas) {
const ctx = canvas.getContext('2d');
canvas.width = canvas.offsetWidth;
canvas.height = 400;

const data = [
{ label: 'Active', value: 198, color: '#10b981' },
{ label: 'Trial', value: 32, color: '#f59e0b' },
{ label: 'Inactive', value: 17, color: '#64748b' }
];

const total = data.reduce((sum, item) => sum + item.value, 0);
const centerX = canvas.width / 2;
const centerY = canvas.height / 2;
const radius = 120;

let currentAngle = -Math.PI / 2;

data.forEach((item) => {
const sliceAngle = (item.value / total) * Math.PI * 2;

ctx.fillStyle = item.color;
ctx.beginPath();
ctx.moveTo(centerX, centerY);
ctx.arc(centerX, centerY, radius, currentAngle, currentAngle + sliceAngle);
ctx.closePath();
ctx.fill();

const labelAngle = currentAngle + sliceAngle / 2;
const labelX = centerX + Math.cos(labelAngle) * (radius + 40);
const labelY = centerY + Math.sin(labelAngle) * (radius + 40);

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 16px Inter';
ctx.textAlign = 'center';
ctx.fillText(item.label, labelX, labelY);

const percentage = ((item.value / total) * 100).toFixed(1);
ctx.font = '14px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText(`${item.value} (${percentage}%)`, labelX, labelY + 20);

currentAngle += sliceAngle;
});

ctx.fillStyle = '#1a2332';
ctx.beginPath();
ctx.arc(centerX, centerY, radius * 0.55, 0, Math.PI * 2);
ctx.fill();

ctx.fillStyle = '#e4e9f0';
ctx.font = 'bold 32px Inter';
ctx.textAlign = 'center';
ctx.fillText(total, centerX, centerY - 10);
ctx.font = '14px Inter';
ctx.fillStyle = '#a8b5c7';
ctx.fillText('Total Businesses', centerX, centerY + 15);
}
}, 100);
}

function showUptimeModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">99.8%</div>
<div class="modal-stat-label">30-Day Uptime</div>
<div class="modal-stat-change" style="color: var(--success);">✓ Excellent</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">99.6%</div>
<div class="modal-stat-label">90-Day Uptime</div>
<div class="modal-stat-change" style="color: var(--success);">✓ Above SLA</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">28d 4h</div>
<div class="modal-stat-label">Current Uptime</div>
<div class="modal-stat-change" style="color: var(--primary);">⏱️ Consecutive</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">14 days</div>
<div class="modal-stat-label">Last Incident</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">🔧 Minor outage</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📊 Incident History (Last 90 Days)</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Major Outages</div>
<div class="detail-item-value" style="color: var(--success);">0</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Minor Incidents</div>
<div class="detail-item-value" style="color: var(--warning);">2</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Total Downtime</div>
<div class="detail-item-value" style="color: var(--text-tertiary);">4h 32m</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Planned Maintenance</div>
<div class="detail-item-value" style="color: var(--primary);">3h 15m</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Uptime Analysis</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• Platform exceeding 99.5% uptime SLA commitment</p>
<p style="margin-bottom: 8px;">• Last incident: Database connection timeout (resolved in 18 minutes)</p>
<p style="margin-bottom: 8px;">• Redundancy systems prevented customer-facing impact in 2 incidents</p>
<p>• Next planned maintenance: December 15th, 2AM-4AM EST</p>
</div>
</div>
`;
createModal('Platform Uptime & Reliability', '⚡', content);
}

function showUsersModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">43,892</div>
<div class="modal-stat-label">Active End Users</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +5,812 this month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">8,234</div>
<div class="modal-stat-label">New Users (30d)</div>
<div class="modal-stat-change" style="color: var(--primary);">👋 First-time visitors</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">42.3%</div>
<div class="modal-stat-label">Repeat Customer Rate</div>
<div class="modal-stat-change" style="color: var(--success);">↗ Strong loyalty</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">67%</div>
<div class="modal-stat-label">Mobile Users</div>
<div class="modal-stat-change" style="color: var(--primary);">📱 Platform usage</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">📱 User Platform Distribution</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">Mobile (iOS + Android)</div>
<div class="detail-item-value" style="color: var(--primary);">29,408 (67%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Desktop/Laptop</div>
<div class="detail-item-value" style="color: var(--success);">12,684 (29%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">Tablet</div>
<div class="detail-item-value" style="color: var(--warning);">1,800 (4%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 User Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 67% mobile usage confirms mobile-first strategy is correct</p>
<p style="margin-bottom: 8px;">• 42.3% repeat rate indicates strong customer satisfaction</p>
<p style="margin-bottom: 8px;">• Average user books 2.4 reservations per month</p>
<p>• Peak booking times: Weekdays 11AM-2PM and weekends 5PM-8PM</p>
</div>
</div>
`;
createModal('Active End Users Analysis', '👥', content);
}

function showRatingModal() {
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">4.7★</div>
<div class="modal-stat-label">Average Rating</div>
<div class="modal-stat-change" style="color: var(--success);">↗ +0.2 improvement</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">8,234</div>
<div class="modal-stat-label">Total Reviews</div>
<div class="modal-stat-change" style="color: var(--primary);">📝 Submitted</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">72%</div>
<div class="modal-stat-label">5-Star Reviews</div>
<div class="modal-stat-change" style="color: var(--success);">⭐ Excellent</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">38%</div>
<div class="modal-stat-label">Review Rate</div>
<div class="modal-stat-change" style="color: var(--primary);">📊 Customers who review</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">⭐ Rating Distribution</div>
<div class="detail-list">
<div class="detail-item">
<div class="detail-item-label">⭐⭐⭐⭐⭐ 5 Stars</div>
<div class="detail-item-value" style="color: var(--success);">5,892 (71.6%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">⭐⭐⭐⭐ 4 Stars</div>
<div class="detail-item-value" style="color: var(--primary);">1,647 (20.0%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">⭐⭐⭐ 3 Stars</div>
<div class="detail-item-value" style="color: var(--warning);">412 (5.0%)</div>
</div>
<div class="detail-item">
<div class="detail-item-label">⭐⭐ 2 Stars & Below</div>
<div class="detail-item-value" style="color: var(--danger);">283 (3.4%)</div>
</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Rating Insights</div>
<div style="background: rgba(16, 185, 129, 0.1); border-left: 3px solid var(--success); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• 4.7-star average places platform in top 10% of restaurant tech</p>
<p style="margin-bottom: 8px;">• 91.6% of reviews are 4-5 stars indicating high satisfaction</p>
<p style="margin-bottom: 8px;">• Response rate to negative reviews: 94% (excellent recovery)</p>
<p>• Common praise: ease of use, quick booking, reliable system</p>
</div>
</div>
`;
createModal('Customer Ratings & Reviews', '⭐', content);
}

function showPlanDetails(planName) {
const planData = {
enterprise: {
name: 'Enterprise Plan',
price: '$1,629/mo',
count: 42,
mrr: '$68,418',
features: 'Unlimited reservations, Priority support, Advanced analytics, Custom branding, API access',
avgReservations: 438
},
professional: {
name: 'Professional Plan',
price: '$437/mo',
count: 89,
mrr: '$38,893',
features: 'Up to 500 reservations/mo, Email support, Standard analytics, Basic customization',
avgReservations: 247
},
starter: {
name: 'Starter Plan',
price: '$148/mo',
count: 116,
mrr: '$17,168',
features: 'Up to 150 reservations/mo, Community support, Basic analytics',
avgReservations: 74
}
};

const plan = planData[planName];
const content = `
<div class="modal-stats-grid">
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.count}</div>
<div class="modal-stat-label">Active Subscriptions</div>
<div class="modal-stat-change" style="color: var(--primary);">🏢 Businesses</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.mrr}</div>
<div class="modal-stat-label">Monthly Revenue</div>
<div class="modal-stat-change" style="color: var(--success);">💰 From this plan</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.price}</div>
<div class="modal-stat-label">Plan Price</div>
<div class="modal-stat-change" style="color: var(--text-tertiary);">Per month</div>
</div>
<div class="modal-stat-card">
<div class="modal-stat-value">${plan.avgReservations}</div>
<div class="modal-stat-label">Avg Reservations</div>
<div class="modal-stat-change" style="color: var(--primary);">📅 Per business/month</div>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">✨ Plan Features</div>
<div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--border-color); padding: 20px; border-radius: 10px;">
<p style="line-height: 1.8; color: var(--text-primary);">${plan.features}</p>
</div>
</div>

<div class="modal-section">
<div class="modal-section-title">💡 Plan Insights</div>
<div style="background: rgba(74, 158, 255, 0.1); border-left: 3px solid var(--primary); padding: 16px; border-radius: 8px;">
<p style="margin-bottom: 8px;">• ${plan.count} businesses actively using ${plan.name}</p>
<p style="margin-bottom: 8px;">• Average ${plan.avgReservations} reservations per business per month</p>
<p style="margin-bottom: 8px;">• Contributing ${((parseFloat(plan.mrr.replace(/[$,K]/g, '')) / 124.5) * 100).toFixed(1)}% to total MRR</p>
<p>• ${planName === 'enterprise' ? 'Highest retention rate at 94.2%' : planName === 'professional' ? 'Popular mid-tier option with 36% of customer base' : 'Great entry point with 78.5% trial conversion'}</p>
</div>
</div>
`;
createModal(plan.name, '💎', content);
}

// ==================== INTERACTION FUNCTIONS ====================
function refreshDashboard() {
showToast('Refreshing dashboard data...', 'info');
setTimeout(() => {
generateActivityFeed();
renderActivityFeed();
updateMetrics();
showToast('Dashboard refreshed successfully!', 'success');
}, 1000);
}

function updateMetrics() {
const totalBusinesses = document.getElementById('totalBusinesses');
const totalReservations = document.getElementById('totalReservations');

const newBusinessCount = parseInt(totalBusinesses.textContent) + Math.floor(Math.random() * 3);
const newReservationCount = parseInt(totalReservations.textContent.replace(',', '')) + Math.floor(Math.random() * 50);

totalBusinesses.textContent = newBusinessCount;
totalReservations.textContent = newReservationCount.toLocaleString();
}

function exportReport() {
showToast('Generating comprehensive report...', 'info');
setTimeout(() => {
showToast('Report exported successfully! Check your downloads.', 'success');
}, 1500);
}

function viewDetailedAnalytics() {
showToast('Opening detailed analytics dashboard...', 'info');
}

function manageSubscriptions() {
showToast('Opening subscription management panel...', 'info');
}

function viewGeographicDistribution() {
showToast('Loading geographic distribution map...', 'info');
}

function setChartPeriod(period) {
dashboardState.chartPeriod = period;
document.querySelectorAll('.chart-btn').forEach(btn => btn.classList.remove('active'));
event.target.classList.add('active');
showToast(`Updated chart to show ${period} data`, 'info');
createRevenueChart();
}

// ==================== REALTIME UPDATES ====================
function startRealtimeUpdates() {
setInterval(() => {
const activityTypes = [
{ icon: '📅', text: 'created a reservation', color: '--primary' },
{ icon: '✅', text: 'checked in a customer', color: '--info' },
{ icon: '⚙️', text: 'updated business settings', color: '--warning' }
];

const business = dashboardState.businesses[Math.floor(Math.random() * Math.min(10, dashboardState.businesses.length))];
const activity = activityTypes[Math.floor(Math.random() * activityTypes.length)];

dashboardState.activities.unshift({
icon: activity.icon,
text: `${business.name} ${activity.text}`,
time: 'Just now',
location: business.owner,
color: activity.color
});

if (dashboardState.activities.length > 20) {
dashboardState.activities.pop();
}

renderActivityFeed();
}, 10000);

setInterval(() => {
dashboardState.activities.forEach(activity => {
if (activity.time === 'Just now') {
activity.time = '1 minute ago';
} else if (activity.time.includes('minute')) {
const minutes = parseInt(activity.time) + 1;
activity.time = minutes < 60 ? `${minutes} minutes ago` : '1 hour ago';
}
});
renderActivityFeed();
}, 60000);
}

// ==================== TOAST NOTIFICATIONS ====================
function showToast(message, type = 'info') {
const colors = {
info: '#4a9eff',
success: '#10b981',
warning: '#f59e0b',
danger: '#ef4444'
};

const toast = document.createElement('div');
toast.style.cssText = `
position: fixed;
bottom: 30px;
right: 30px;
background: var(--bg-card);
border: 1px solid ${colors[type]};
border-left: 4px solid ${colors[type]};
padding: 16px 20px;
border-radius: 8px;
box-shadow: 0 8px 30px rgba(0, 0, 0, 0.4);
color: var(--text-primary);
font-size: 13px;
font-weight: 600;
z-index: 10000;
animation: slideIn 0.3s ease-out;
backdrop-filter: blur(10px);
max-width: 400px;
`;

toast.textContent = message;
document.body.appendChild(toast);

setTimeout(() => {
toast.style.animation = 'slideOut 0.3s ease-out';
setTimeout(() => toast.remove(), 300);
}, 3000);
}

const style = document.createElement('style');
style.textContent = `
@keyframes slideIn {
from {
transform: translateX(400px);
opacity: 0;
}
to {
transform: translateX(0);
opacity: 1;
}
}
@keyframes slideOut {
from {
transform: translateX(0);
opacity: 1;
}
to {
transform: translateX(400px);
opacity: 0;
}
}
`;
document.head.appendChild(style);

// ==================== SEARCH AND FILTER ====================
document.getElementById('searchBusinesses')?.addEventListener('input', (e) => {
const searchTerm = e.target.value.toLowerCase();
const filteredBusinesses = dashboardState.businesses.filter(business =>
business.name.toLowerCase().includes(searchTerm) ||
business.owner.toLowerCase().includes(searchTerm)
);
renderFilteredBusinessTable(filteredBusinesses);
});

document.getElementById('filterStatus')?.addEventListener('change', (e) => {
const status = e.target.value;
const filteredBusinesses = status === 'all'
? dashboardState.businesses
: dashboardState.businesses.filter(business => business.status === status);
renderFilteredBusinessTable(filteredBusinesses);
});

function renderFilteredBusinessTable(businesses) {
const tbody = document.getElementById('businessTable');
tbody.innerHTML = businesses.map(business => `
<tr onclick="showBusinessDetailsModal(${business.id})" style="cursor: pointer;">
<td>
<div style="display: flex; align-items: center; gap: 10px;">
<div style="width: 36px; height: 36px; border-radius: 8px; background: linear-gradient(135deg, var(--primary), var(--purple)); display: flex; align-items: center; justify-content: center; font-weight: 700;">
${business.name.charAt(0)}
</div>
<strong>${business.name}</strong>
</div>
</td>
<td>${business.owner}</td>
<td><span class="badge badge-primary">${business.plan}</span></td>
<td><span class="status-badge status-${business.status}">${business.status}</span></td>
<td>${business.template}</td>
<td><strong>${business.reservations}</strong></td>
<td><strong style="color: var(--success);">$${business.revenue}</strong></td>
<td>${business.joinDate}</td>
<td>
<button style="padding: 6px 12px; background: var(--primary); border: none; border-radius: 6px; color: white; cursor: pointer; font-size: 11px; font-weight: 600;" onclick="event.stopPropagation(); showBusinessDetailsModal(${business.id})">
View Details
</button>
</td>
</tr>
`).join('');
}

// ==================== INITIALIZE ON LOAD ====================
window.addEventListener('DOMContentLoaded', initializeDashboard);

</script>
</body>
</html>
