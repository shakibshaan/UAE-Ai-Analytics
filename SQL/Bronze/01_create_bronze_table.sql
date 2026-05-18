/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


USE UAE_AI_Analytics;


IF OBJECT_ID ('bronze.raw_users', 'U') IS NOT NULL 
    DROP TABLE bronze.raw_users;
GO

CREATE TABLE bronze.raw_users (
    user_id              NVARCHAR(MAX),
    full_name            NVARCHAR(MAX),
    email                NVARCHAR(MAX),
    age                  NVARCHAR(MAX),
    gender               NVARCHAR(MAX),
    city                 NVARCHAR(MAX),
    nationality          NVARCHAR(MAX),
    occupation           NVARCHAR(MAX),
    signup_date          NVARCHAR(MAX),
    plan_type            NVARCHAR(MAX),
    is_active            NVARCHAR(MAX),
    phone_number         NVARCHAR(MAX)
);
GO

IF OBJECT_ID ('bronze.raw_ai_tools', 'U') IS NOT NULL 
    DROP TABLE bronze.raw_ai_tools;
GO

CREATE TABLE bronze.raw_ai_tools (
    tool_id              NVARCHAR(MAX),
    tool_name            NVARCHAR(MAX),
    category             NVARCHAR(MAX),
    pricing_model        NVARCHAR(MAX),
    monthly_active_users_millions NVARCHAR(MAX),
    launch_year          NVARCHAR(MAX),
    parent_company       NVARCHAR(MAX),
    avg_user_rating      NVARCHAR(MAX),
    uae_popularity_rank  NVARCHAR(MAX)
);
GO

IF OBJECT_ID ('bronze.raw_ai_usage_logs', 'U') IS NOT NULL 
    DROP TABLE bronze.raw_ai_usage_logs;
GO

CREATE TABLE bronze.raw_ai_usage_logs (
    log_id                       NVARCHAR(MAX),
    user_id                      NVARCHAR(MAX),
    tool_id                      NVARCHAR(MAX),
    session_date                 NVARCHAR(MAX),
    session_duration_minutes     NVARCHAR(MAX),
    prompts_per_session          NVARCHAR(MAX),
    prompt_category              NVARCHAR(MAX),
    device_type                  NVARCHAR(MAX),
    satisfaction_score           NVARCHAR(MAX),
    tokens_used                  NVARCHAR(MAX)
);
GO

IF OBJECT_ID ('bronze.raw_feedback', 'U') IS NOT NULL 
    DROP TABLE bronze.raw_feedback;
GO

CREATE TABLE bronze.raw_feedback (
    feedback_id                  NVARCHAR(MAX),
    user_id                      NVARCHAR(MAX),
    tool_id                      NVARCHAR(MAX),
    feedback_date                NVARCHAR(MAX),
    rating                       NVARCHAR(MAX),
    feedback_text                NVARCHAR(MAX),
    feedback_category            NVARCHAR(MAX),
    sentiment                    NVARCHAR(MAX),
    would_recommend              NVARCHAR(MAX)
);
GO

IF OBJECT_ID ('bronze.raw_subscriptions', 'U') IS NOT NULL 
    DROP TABLE bronze.raw_subscriptions;
GO

CREATE TABLE bronze.raw_subscriptions (
    subscription_id              NVARCHAR(MAX),
    user_id                      NVARCHAR(MAX),
    plan_type                    NVARCHAR(MAX),
    currency                     NVARCHAR(MAX),
    amount_paid                  NVARCHAR(MAX),
    starting_date                NVARCHAR(MAX),
    ending_date                  NVARCHAR(MAX),
    [status]                     NVARCHAR(MAX),    
    billing_cycle                NVARCHAR(MAX),
    auto_renew                   NVARCHAR(MAX)                   
);
